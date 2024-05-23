

gcloud services enable healthcare.googleapis.com


gcloud healthcare datasets create $DATASET_ID \
--location=$REGION

sleep 30

PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")

SERVICE_ACCOUNT="service-${PROJECT_NUMBER}@gcp-sa-healthcare.iam.gserviceaccount.com"


gcloud projects add-iam-policy-binding $PROJECT_NUMBER \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/bigquery.admin

gcloud projects add-iam-policy-binding $PROJECT_NUMBER \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/storage.objectAdmin

gcloud projects add-iam-policy-binding $PROJECT_NUMBER \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/healthcare.datasetAdmin

gcloud projects add-iam-policy-binding $PROJECT_NUMBER \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/pubsub.publisher



gcloud pubsub topics create projects/$PROJECT_ID/topics/hl7topic


gcloud pubsub subscriptions create hl7_subscription --topic=hl7topic


gcloud healthcare hl7v2-stores create $HL7_STORE_ID --dataset=$DATASET_ID --location=$REGION --notification-config=pubsub-topic=projects/$PROJECT_ID/topics/hl7topic


