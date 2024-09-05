
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

gcloud container clusters get-credentials day2-ops --region $REGION

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git


cd microservices-demo

kubectl apply -f release/kubernetes-manifests.yaml

sleep 45

kubectl get pods


export EXTERNAL_IP=$(kubectl get service frontend-external -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo $EXTERNAL_IP

curl -o /dev/null -s -w "%{http_code}\n"  http://${EXTERNAL_IP}


gcloud logging buckets update _Default --project=$DEVSHELL_PROJECT_ID --location=global --enable-analytics


gcloud logging sinks create day2ops-sink \
    logging.googleapis.com/projects/$DEVSHELL_PROJECT_ID/locations/global/buckets/day2ops-log \
    --log-filter='resource.type="k8s_container"' \
    --include-children --format='json'


echo "Click this link to open Log bucket! [https://console.cloud.google.com/logs/storage/bucket?cloudshell=true&project=$DEVSHELL_PROJECT_ID]"


