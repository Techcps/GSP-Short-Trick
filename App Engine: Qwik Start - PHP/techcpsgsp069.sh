
gcloud auth list
gcloud config list project
gcloud config set compute/region $REGION

gcloud services enable appengine.googleapis.com

git clone https://github.com/GoogleCloudPlatform/php-docs-samples.git

cd php-docs-samples/appengine/standard/helloworld

gcloud app deploy

gcloud app browse
