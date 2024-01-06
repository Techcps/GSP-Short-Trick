


gcloud auth list
gcloud config list project
export PROJECT_ID=$(gcloud info --format="value(config.project)")
git clone https://github.com/GoogleCloudPlatform/DIY-Tools.git
gcloud firestore import gs://$PROJECT_ID-firestore/prd-back
cd ~/DIY-Tools/gcp-data-drive
gcloud builds submit --config cloudbuild_run.yaml --project $PROJECT_ID --no-source --substitutions=_GIT_SOURCE_BRANCH="master",_GIT_SOURCE_URL="https://github.com/GoogleCloudPlatform/DIY-Tools"
export CLOUD_RUN_SERVICE_URL=$(gcloud run services --platform managed describe gcp-data-drive --region us-central1 --format="value(status.url)")
curl $CLOUD_RUN_SERVICE_URL/fs/$PROJECT_ID/symbols/product/symbol | jq .
curl $CLOUD_RUN_SERVICE_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes | jq .
gcloud builds submit --config cloudbuild_gcf.yaml --project $PROJECT_ID --no-source --substitutions=_GIT_SOURCE_BRANCH="master",_GIT_SOURCE_URL="https://github.com/GoogleCloudPlatform/DIY-Tools"
gcloud alpha functions add-iam-policy-binding gcp-data-drive --member=allUsers --role=roles/cloudfunctions.invoker
export CF_TRIGGER_URL=$(gcloud functions describe gcp-data-drive --format="value(httpsTrigger.url)")
curl $CF_TRIGGER_URL/fs/$PROJECT_ID/symbols/product/symbol | jq .
curl $CF_TRIGGER_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes
gcloud builds submit --config cloudbuild_appengine.yaml --project $PROJECT_ID --no-source --substitutions=_GIT_SOURCE_BRANCH="master",_GIT_SOURCE_URL="https://github.com/GoogleCloudPlatform/DIY-Tools"
export TARGET_URL=https://$(gcloud app describe --format="value(defaultHostname)")
curl $TARGET_URL/fs/$PROJECT_ID/symbols/product/symbol | jq .
curl $TARGET_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes | jq .
cat > loadgen.sh <<EOF
#!/bin/bash
for ((i=1;i<=1000;i++));
do
curl $TARGET_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes > /dev/null &
done
EOF
chmod +x loadgen.sh
./loadgen.sh

