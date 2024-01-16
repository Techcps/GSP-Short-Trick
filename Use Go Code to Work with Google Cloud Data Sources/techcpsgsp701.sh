
export PROJECT_ID=$(gcloud info --format="value(config.project)")
go version
git clone https://github.com/GoogleCloudPlatform/DIY-Tools.git
gcloud firestore import gs://$PROJECT_ID-firestore/prd-back
export PROJECT_ID=$(gcloud info --format="value(config.project)")
export PREVIEW_URL=[REPLACE_WITH_WEB_PREVIEW_URL]
echo $PREVIEW_URL/fs/$PROJECT_ID/symbols/product/symbol
# please like share & subscribe to techcps
cd ~/DIY-Tools/gcp-data-drive/cmd/webserver
gcloud app deploy app.yaml --project $PROJECT_ID -q
export TARGET_URL=https://$(gcloud app describe --format="value(defaultHostname)")
curl $TARGET_URL/fs/$PROJECT_ID/symbols/product/symbol
curl $TARGET_URL/fs/$PROJECT_ID/symbols/product/symbol/008888166900
curl $TARGET_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes
