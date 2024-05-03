
 
gcloud auth list

gcloud services enable iap.googleapis.com

gcloud config set project $DEVSHELL_PROJECT_ID

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/appengine/standard_python3/hello_world/
gcloud app create --project=$(gcloud config get-value project) --region=$REGION

gcloud app deploy --quiet

