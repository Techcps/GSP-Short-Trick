
gcloud auth list
gcloud config set project $DEVSHELL_PROJECT_ID

gcloud config set run/region $REGION

gcloud config set run/platform managed

gcloud config set eventarc/location $REGION

# Task 2

export PROJECT_NUMBER="$(gcloud projects list \
  --filter=$(gcloud config get-value project) \
  --format='value(PROJECT_NUMBER)')"


gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role='roles/eventarc.admin'


# Task 3

gcloud eventarc providers list

gcloud eventarc providers describe \
  pubsub.googleapis.com


# Task 4


export SERVICE_NAME=event-display

export IMAGE_NAME="gcr.io/cloudrun/hello"

gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --allow-unauthenticated \
  --max-instances=3


# Task 5

gcloud eventarc providers describe \
  pubsub.googleapis.com

gcloud eventarc triggers create trigger-pubsub \
  --destination-run-service=${SERVICE_NAME} \
  --event-filters="type=google.cloud.pubsub.topic.v1.messagePublished"

export TOPIC_ID=$(gcloud eventarc triggers describe trigger-pubsub \
  --format='value(transport.pubsub.topic)')

echo ${TOPIC_ID}

gcloud eventarc triggers list

gcloud pubsub topics publish ${TOPIC_ID} --message="Hello there"



export BUCKET_NAME=$(gcloud config get-value project)-cr-bucket


gsutil mb -p $(gcloud config get-value project) \
  -l $(gcloud config get-value run/region) \
  gs://${BUCKET_NAME}/


echo " Click this link to open Audit Logs,[https://console.cloud.google.com/iam-admin/audit?referrer=search&cloudshell=true&project=$DEVSHELL_PROJECT_ID]"
