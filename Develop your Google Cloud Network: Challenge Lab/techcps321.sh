
gcloud auth list

gcloud config set compute/zone $ZONE

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION


gcloud compute networks create griffin-dev-vpc --project=$DEVSHELL_PROJECT_ID --subnet-mode custom

gcloud compute networks subnets create griffin-dev-wp --project=$DEVSHELL_PROJECT_ID --region $REGION --network=griffin-dev-vpc --range=192.168.16.0/20 && gcloud compute networks subnets create griffin-dev-mgmt --project=$DEVSHELL_PROJECT_ID --region $REGION --network=griffin-dev-vpc --range=192.168.32.0/20


gcloud compute networks create griffin-prod-vpc --project=$DEVSHELL_PROJECT_ID --subnet-mode custom

gcloud compute networks subnets create griffin-prod-wp --project=$DEVSHELL_PROJECT_ID --region $REGION --network=griffin-prod-vpc --range=192.168.48.0/20 && gcloud compute networks subnets create griffin-prod-mgmt --project=$DEVSHELL_PROJECT_ID --region $REGION --network=griffin-prod-vpc --range=192.168.64.0/20


gcloud compute instances create bastion --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --network-interface=network=griffin-dev-vpc,subnet=griffin-dev-mgmt --network-interface=network=griffin-prod-vpc,subnet=griffin-prod-mgmt --tags=ssh

gcloud compute firewall-rules create fw-ssh-dev --project=$DEVSHELL_PROJECT_ID --source-ranges=0.0.0.0/0 --target-tags=ssh --allow=tcp:22 --network=griffin-dev-vpc && gcloud compute firewall-rules create fw-ssh-prod --project=$DEVSHELL_PROJECT_ID --source-ranges=0.0.0.0/0 --target-tags=ssh --allow=tcp:22 --network=griffin-prod-vpc


gcloud sql instances create griffin-dev-db --project=$DEVSHELL_PROJECT_ID --region=$REGION --database-version=MYSQL_5_7 --root-password='awesome'

gcloud sql databases create wordpress --instance=griffin-dev-db

gcloud sql users create wp_user --instance=griffin-dev-db --password=stormwind_rules

gcloud sql users set-password wp_user --instance=griffin-dev-db --password=stormwind_rules

gcloud sql users list --instance=griffin-dev-db --format="value(name)" --filter="host='%'"


gcloud container clusters create griffin-dev --zone $ZONE --machine-type e2-standard-4 --network griffin-dev-vpc --subnetwork griffin-dev-wp --num-nodes 2

gcloud container clusters get-credentials griffin-dev --zone $ZONE

cd ~/
gsutil cp -r gs://cloud-training/gsp321/wp-k8s .

cat > wp-k8s/wp-env.yaml <<'EOF_CP'
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: wordpress-volumeclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 200Gi
---
apiVersion: v1
kind: Secret
metadata:
  name: database
type: Opaque
stringData:
  username: wp_user
  password: stormwind_rules
EOF_CP

cd wp-k8s
kubectl create -f wp-env.yaml

gcloud iam service-accounts keys create key.json --iam-account=cloud-sql-proxy@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com

kubectl create secret generic cloudsql-instance-credentials --from-file=key.json



# Get the connection name of the SQL instance
INSTANCE_ID=$(gcloud sql instances describe griffin-dev-db --format='value(connectionName)')

# Create the wp-deployment.yaml file
cat > wp-deployment.yaml <<EOF_CP
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
        - image: wordpress
          name: wordpress
          env:
          - name: WORDPRESS_DB_HOST
            value: 127.0.0.1:3306
          - name: WORDPRESS_DB_USER
            valueFrom:
              secretKeyRef:
                name: database
                key: username
          - name: WORDPRESS_DB_PASSWORD
            valueFrom:
              secretKeyRef:
                name: database
                key: password
          ports:
            - containerPort: 80
              name: wordpress
          volumeMounts:
            - name: wordpress-persistent-storage
              mountPath: /var/www/html
        - name: cloudsql-proxy
          image: gcr.io/cloudsql-docker/gce-proxy:1.33.2
          command: ["/cloud_sql_proxy",
                    "-instances=${INSTANCE_ID}=tcp:3306",
                    "-credential_file=/secrets/cloudsql/key.json"]
          securityContext:
            runAsUser: 2  # non-root user
            allowPrivilegeEscalation: false
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
      volumes:
        - name: wordpress-persistent-storage
          persistentVolumeClaim:
            claimName: wordpress-volumeclaim
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials

EOF_CP

# Apply the deployment and service configurations
kubectl create -f wp-deployment.yaml
kubectl create -f wp-service.yaml




IAM_POLICY_JSON=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json)
USERS=$(echo $IAM_POLICY_JSON | jq -r '.bindings[] | select(.role == "roles/viewer").members[]')


for USER in $USERS; do
  if [[ $USER == *"user:"* ]]; then
    USER_EMAIL=$(echo $USER | cut -d':' -f2)
    gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=user:$USER_EMAIL --role=roles/editor
  fi
done


get_external_ip=$(kubectl get service wordpress  -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "http://${get_external_ip}"


#!/bin/bash

get_external_ip() {
    kubectl get service wordpress  -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
}

echo "http://${get_external_ip}"

# Wait for external IP address to become available
wait_for_external_ip() {
    echo "Waiting for External IP address.."
    local external_ip
    for _ in {1..10}; do
        external_ip=$(get_external_ip)
        if [ -n "$external_ip" ]; then
            echo "External IP address found: $external_ip"
            WORDPRESS_EXTERNAL_IP="$external_ip"
            return 0
        fi
        sleep 20
    done
    echo "Timeout: External IP address not found."
    return 1
}


if wait_for_external_ip; then
    echo "Executing next command..."
    echo "Do something with $WORDPRESS_EXTERNAL_IP"
else
    echo "Exiting script."
    exit 1
fi


gcloud monitoring uptime create techcps --resource-type=uptime-url --resource-labels=host=$WORDPRESS_EXTERNAL_IP

echo "http://${get_external_ip}"


