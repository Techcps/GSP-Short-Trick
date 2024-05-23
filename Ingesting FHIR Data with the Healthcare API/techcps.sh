

export REGION=$LOCATION

gcloud services enable healthcare.googleapis.com


bq --location=$REGION mk --dataset --description HCAPI-dataset $PROJECT_ID:$DATASET_ID

bq --location=$REGION mk --dataset --description HCAPI-dataset-de-id $PROJECT_ID:de_id


gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/bigquery.dataEditor
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com \
--role=roles/bigquery.jobUser


gcloud healthcare datasets create $DATASET_ID \
--location=$LOCATION


gcloud pubsub topics create fhir-topic


gcloud healthcare fhir-stores create ${FHIR_STORE_ID} --project=$DEVSHELL_PROJECT_ID --dataset=${DATASET_ID} --location=${LOCATION} --version=R4 --pubsub-topic=projects/${PROJECT_ID}/topics/${TOPIC} --enable-update-create --disable-referential-integrity


gcloud healthcare fhir-stores create de_id --project=$DEVSHELL_PROJECT_ID --dataset=${DATASET_ID} --location=${LOCATION} --version=R4 --pubsub-topic=projects/${PROJECT_ID}/topics/${TOPIC} --enable-update-create --disable-referential-integrity


gcloud healthcare fhir-stores import gcs $FHIR_STORE_ID \
--dataset=$DATASET_ID \
--location=$LOCATION \
--gcs-uri=gs://spls/gsp457/fhir_devdays_gcp/fhir1/* \
--content-structure=BUNDLE_PRETTY


gcloud healthcare fhir-stores export bq $FHIR_STORE_ID \
--dataset=$DATASET_ID \
--location=$LOCATION \
--bq-dataset=bq://$PROJECT_ID.$DATASET_ID \
--schema-type=analytics


