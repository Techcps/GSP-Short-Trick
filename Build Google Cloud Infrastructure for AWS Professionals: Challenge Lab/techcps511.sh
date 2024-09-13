

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION


gcloud compute networks create griffin-dev-vpc --project=$DEVSHELL_PROJECT_ID --subnet-mode custom && gcloud compute networks subnets create griffin-dev-wp --project=$DEVSHELL_PROJECT_ID --region=$REGION --range=192.168.16.0/20 --network=griffin-dev-vpc && gcloud compute networks subnets create griffin-dev-mgmt --project=$DEVSHELL_PROJECT_ID --region=$REGION --network=griffin-dev-vpc --range=192.168.32.0/20


gsutil cp -r gs://cloud-training/gsp321/dm .

cd dm

sed -i s/SET_REGION/$REGION/g prod-network.yaml

gcloud deployment-manager deployments create prod-network \
    --config=prod-network.yaml

cd ..
griffin-prod-wp


gcloud compute instances create bastion --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --network-interface=network=griffin-dev-vpc,subnet=griffin-dev-mgmt --network-interface=network=griffin-prod-vpc,subnet=griffin-prod-mgmt --tags=ssh && gcloud compute firewall-rules create fw-ssh-dev --project=$DEVSHELL_PROJECT_ID --target-tags ssh --allow=tcp:22 --network=griffin-dev-vpc --source-ranges=0.0.0.0/0 && gcloud compute firewall-rules create fw-ssh-prod --project=$DEVSHELL_PROJECT_ID --target-tags ssh --allow=tcp:22 --network=griffin-prod-vpc --source-ranges=0.0.0.0/0


gcloud sql instances create griffin-dev-db --project=$DEVSHELL_PROJECT_ID  --region=$REGION --database-version=MYSQL_5_7 --root-password="techcps"


gcloud sql databases create wordpress --instance=griffin-dev-db --project=$DEVSHELL_PROJECT_ID

gcloud sql users create wp_user --instance=griffin-dev-db --instance=griffin-dev-db --password=stormwind_rules && gcloud sql users set-password wp_user --instance=griffin-dev-db --instance=griffin-dev-db --password=stormwind_rules && gcloud sql users list --instance=griffin-dev-db --instance=griffin-dev-db --format="value(name)" --filter="host='%'"


gcloud container clusters create griffin-dev --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type e2-standard-4 --network griffin-dev-vpc --subnetwork griffin-dev-wp --num-nodes 2 && gcloud container clusters get-credentials griffin-dev --project=$DEVSHELL_PROJECT_ID --zone=$ZONE

cd ~/

gsutil cp -r gs://cloud-training/gsp321/wp-k8s .


cat > wp-k8s/wp-env.yaml <<EOF_CP
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


gcloud iam service-accounts keys create key.json \
    --iam-account=cloud-sql-proxy@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
kubectl create secret generic cloudsql-instance-credentials \
    --from-file key.json



INSTANCE_ID=$(gcloud sql instances describe griffin-dev-db --project=$DEVSHELL_PROJECT_ID --format='value(connectionName)')


wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Build%20Google%20Cloud%20Infrastructure%20for%20AWS%20Professionals%3A%20Challenge%20Lab/wp-deployment.yaml


kubectl create -f wp-deployment.yaml

kubectl create -f wp-service.yaml



IAM_POLICY_JSON=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json)


USERS=$(echo $IAM_POLICY_JSON | jq -r '.bindings[] | select(.role == "roles/viewer").members[]')


for USER in $USERS; do
  if [[ $USER == *"user:"* ]]; then
    USER_EMAIL=$(echo $USER | cut -d':' -f2)
    gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
      --member=user:$USER_EMAIL \
      --role=roles/editor
  fi
done



sleep 60


EXTERNAL_IP=$(kubectl get services wordpress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')


cat > terraform.tfvars <<EOF_CP
devsell_project_id = "$DEVSHELL_PROJECT_ID"
external_ip        = "$EXTERNAL_IP"

EOF_CP


wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Build%20Google%20Cloud%20Infrastructure%20for%20AWS%20Professionals%3A%20Challenge%20Lab/techcps.tf

terraform init
terraform apply --auto-approve


