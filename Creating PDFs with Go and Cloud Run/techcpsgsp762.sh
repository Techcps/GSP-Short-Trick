
gcloud services enable cloudbuild.googleapis.com
gcloud services enable storage-component.googleapis.com
gcloud services enable run.googleapis.com

gcloud auth list --filter=status:ACTIVE --format="value(account)"

git clone https://github.com/Deleplace/pet-theory.git

cd pet-theory/lab03

curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Creating%20PDFs%20with%20Go%20and%20Cloud%20Run/server.go

go build -o server

curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Creating%20PDFs%20with%20Go%20and%20Cloud%20Run/Dockerfile

gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter

gcloud run deploy pdf-converter --image gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter --platform managed --region "$REGION" --memory=2Gi --no-allow-unauthenticated --set-env-vars PDF_BUCKET=$GOOGLE_CLOUD_PROJECT-processed --max-instances=3

gsutil notification create -t new-doc -f json -e OBJECT_FINALIZE gs://$GOOGLE_CLOUD_PROJECT-upload

gcloud iam service-accounts create pubsub-cloud-run-invoker --display-name "PubSub Cloud Run Invoker"

gcloud run services add-iam-policy-binding pdf-converter --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com --role=roles/run.invoker --region "$REGION" --platform managed

PROJECT_NUMBER=$(gcloud projects list --format="value(PROJECT_NUMBER)" --filter="$GOOGLE_CLOUD_PROJECT")

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com --role=roles/iam.serviceAccountTokenCreator

SERVICE_URL=$(gcloud run services describe pdf-converter --platform managed --region "$REGION" --format "value(status.url)")

echo $SERVICE_URL

curl -X GET $SERVICE_URL

curl -X GET -H "Authorization: Bearer $(gcloud auth print-identity-token)" $SERVICE_URL

gcloud pubsub subscriptions create pdf-conv-sub --topic new-doc --push-endpoint=$SERVICE_URL --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com

