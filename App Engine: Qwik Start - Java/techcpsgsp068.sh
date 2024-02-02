
gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)

gcloud services enable appengine.googleapis.com

git clone https://github.com/GoogleCloudPlatform/java-docs-samples.git

cd java-docs-samples/appengine-java8/helloworld

mvn clean
mvn package

mvn appengine:run 

gcloud app create --region=$REGION

sed -i "s/myProjectId/$PROJECT_ID/g" pom.xml

mvn package appengine:deploy

gcloud app browse

