
gcloud auth list
gcloud config set compute/region $REGION

gcloud config set project $DEVSHELL_PROJECT_ID

gcloud services enable appengine.googleapis.com

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git


cd python-docs-samples/appengine/standard_python3/hello_world

cd python-docs-samples/appengine/standard_python3/hello_world


sed -i 's/Hello World!/Hello, Cruel World!/g' main.py

gcloud app create --region=$REGION

gcloud app deploy --quiet 

