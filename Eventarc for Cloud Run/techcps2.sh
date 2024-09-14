
export PROJECT_NUMBER="$(gcloud projects list \
  --filter=$(gcloud config get-value project) \
  --format='value(PROJECT_NUMBER)')"


export SERVICE_NAME=event-display

export IMAGE_NAME="gcr.io/cloudrun/hello"

export BUCKET_NAME=$(gcloud config get-value project)-cr-bucket


gcloud eventarc triggers delete trigger-pubsub


echo "Hello World" > random.txt

gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

gcloud eventarc providers describe cloudaudit.googleapis.com


gcloud eventarc triggers create trigger-auditlog \
  --destination-run-service=${SERVICE_NAME} \
  --event-filters="type=google.cloud.audit.log.v1.written" \
  --event-filters="serviceName=storage.googleapis.com" \
  --event-filters="methodName=storage.objects.create" \
  --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com


gcloud eventarc triggers list

gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

sleep 5 

gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

gsutil cp random.txt gs://${BUCKET_NAME}/random.txt
sleep 5
gsutil cp random.txt gs://${BUCKET_NAME}/random.txt

