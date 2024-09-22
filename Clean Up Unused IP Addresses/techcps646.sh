

gcloud auth list

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com 

gcloud services enable run.googleapis.com

gcloud services enable cloudscheduler.googleapis.com

sleep 30

git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
WORKDIR=$(pwd)

sleep 10

cd $WORKDIR/unused-ip

export USED_IP=used-ip-address
export UNUSED_IP=unused-ip-address


gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=$REGION

sleep 5

gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$REGION

sleep 15

gcloud compute addresses list --filter="region:($REGION)"

export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=$REGION --format=json | jq -r '.address')

gcloud compute instances create static-ip-instance \
--zone=$ZONE \
--project=$PROJECT_ID \
--machine-type=e2-medium \
--subnet=default \
--address=$USED_IP_ADDRESS

gcloud compute addresses list --filter="region:($REGION)"

cat $WORKDIR/unused-ip/function.js | grep "const compute" -A 31


gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"


PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

deploy_function() {
    gcloud functions deploy unused_ip_function --gen2 --trigger-http --runtime=nodejs20 --region=$REGION --allow-unauthenticated --quiet
}

SERVICE_NAME="unused_ip_function"

while true; do
  deploy_function
  if gcloud functions describe $SERVICE_NAME --region=$REGION &> /dev/null; then
    echo "Function deployed successfully."
    break
  else
    echo "Retrying, please subscribe to techcps[https://www.youtube.com/@techcps]"
    sleep 20
  fi
done


export FUNCTION_URL=$(gcloud functions describe unused_ip_function --region=$REGION --format=json | jq -r '.httpsTrigger.url')

if [ "$REGION" == "us-central1" ]; then
  gcloud app create --region us-central
else
  gcloud app create --region "$REGION"
fi


gcloud app create --region $REGION

gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=$REGION

sleep 45 

gcloud scheduler jobs run unused-ip-job \
--location=$REGION


gcloud compute addresses list --filter="region:($REGION)"


export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
WORKDIR=$(pwd)

cd $WORKDIR/unused-ip

export UNUSED_IP=unused-ip-address

gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$REGION

sleep 15

gcloud compute addresses list --filter="region:($REGION)"

