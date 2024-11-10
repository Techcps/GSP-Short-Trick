
echo "Please set the below values correctly"

# Export the Zone name correctly
read -p "Enter the REGION: " REGION


mkdir ./documentai-pipeline-demo
gcloud storage cp -r \
  gs://spls/gsp927/documentai-pipeline-demo/* \
  ~/documentai-pipeline-demo/

export PROCESSOR_NAME=form-processor

ACCESS_TOKEN=$(gcloud auth application-default print-access-token)

curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "display_name": "'"$PROCESSOR_NAME"'",
    "type": "FORM_PARSER_PROCESSOR"
  }' \
  "https://documentai.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/us/processors"


export PROJECT_ID=$(gcloud config get-value core/project)
export BUCKET_LOCATION="$REGION"
gsutil mb -c standard -l ${BUCKET_LOCATION} -b on \
  gs://${PROJECT_ID}-input-invoices
gsutil mb -c standard -l ${BUCKET_LOCATION} -b on \
  gs://${PROJECT_ID}-output-invoices
gsutil mb -c standard -l ${BUCKET_LOCATION} -b on \
  gs://${PROJECT_ID}-archived-invoices


bq --location="US" mk  -d \
    --description "Form Parser Results" \
    ${PROJECT_ID}:invoice_parser_results
cd ~/documentai-pipeline-demo/scripts/table-schema/
bq mk --table \
  invoice_parser_results.doc_ai_extracted_entities \
  doc_ai_extracted_entities.json
bq mk --table \
  invoice_parser_results.geocode_details \
  geocode_details.json


export GEO_CODE_REQUEST_PUBSUB_TOPIC=geocode_request
gcloud pubsub topics \
  create ${GEO_CODE_REQUEST_PUBSUB_TOPIC}

gcloud storage service-agent --project=$PROJECT_ID


PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

gcloud iam service-accounts create "service-$PROJECT_NUMBER" \
  --display-name "Cloud Storage Service Account" || true

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-$PROJECT_NUMBER@gs-project-accounts.iam.gserviceaccount.com" \
  --role="roles/pubsub.publisher"
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-$PROJECT_NUMBER@gs-project-accounts.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator"


  cd ~/documentai-pipeline-demo/scripts


  export CLOUD_FUNCTION_LOCATION="$REGION"
  
  deploy_function() {
  gcloud functions deploy process-invoices \
  --gen2 \
  --region=${CLOUD_FUNCTION_LOCATION} \
  --entry-point=process_invoice \
  --runtime=python39 \
  --source=cloud-functions/process-invoices \
  --timeout=400 \
  --env-vars-file=cloud-functions/process-invoices/.env.yaml \
  --trigger-resource=gs://${PROJECT_ID}-input-invoices \
  --trigger-event=google.storage.object.finalize
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully [https://www.youtube.com/@techcps].."
    deploy_success=true
  else
    echo "please subscribe to techcps [https://www.youtube.com/@techcps]."
    sleep 20
  fi
done



deploy_function() {
gcloud functions deploy geocode-addresses \
  --gen2 \
  --region=${REGION} \
  --entry-point=process_address \
  --runtime=python39 \
  --source=cloud-functions/geocode-addresses \
  --timeout=60 \
  --env-vars-file=cloud-functions/geocode-addresses/.env.yaml \
  --trigger-topic=${GEO_CODE_REQUEST_PUBSUB_TOPIC}
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully [https://www.youtube.com/@techcps].."
    deploy_success=true
  else
    echo "please subscribe to techcps [https://www.youtube.com/@techcps]."
    sleep 20
  fi
done


PROCESSOR_ID=$(curl -X GET \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json" \
  "https://documentai.googleapis.com/v1/projects/$PROJECT_ID/locations/us/processors" | \
  grep '"name":' | \
  sed -E 's/.*"name": "projects\/[0-9]+\/locations\/us\/processors\/([^"]+)".*/\1/')


echo "$PROCESSOR_ID"

export PROCESSOR_ID


gcloud functions deploy process-invoices \
  --gen2 \
  --region=${REGION} \
  --entry-point=process_invoice \
  --runtime=python39 \
  --source=cloud-functions/process-invoices \
  --timeout=400 \
  --update-env-vars=PROCESSOR_ID=${PROCESSOR_ID},PARSER_LOCATION=us,GCP_PROJECT=${PROJECT_ID} \
  --trigger-resource=gs://${PROJECT_ID}-input-invoices \
  --trigger-event=google.storage.object.finalize


KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")

export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")


gcloud functions deploy geocode-addresses \
  --gen2 \
  --region=${REGION} \
  --entry-point=process_address \
  --runtime=python39 \
  --source=cloud-functions/geocode-addresses \
  --timeout=60 \
  --update-env-vars=API_key=${API_KEY} \
  --trigger-topic=${GEO_CODE_REQUEST_PUBSUB_TOPIC}
  

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil cp gs://spls/gsp927/documentai-pipeline-demo/sample-files/* gs://${PROJECT_ID}-input-invoices/



