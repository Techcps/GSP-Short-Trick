


export REGION=${ZONE%-*}
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
gcloud config set compute/region $REGION


gcloud services enable \
  cloudresourcemanager.googleapis.com \
  container.googleapis.com \
  artifactregistry.googleapis.com \
  containerregistry.googleapis.com \
  containerscanning.googleapis.com

sleep 30


git clone https://github.com/GoogleCloudPlatform/cloud-code-samples/
cd ~/cloud-code-samples

gcloud container clusters create container-dev-cluster --zone=$ZONE


gcloud artifacts repositories create container-dev-repo --repository-format=docker \
  --location=$REGION \
  --description="Docker repository for Container Dev Workshop"

gcloud auth configure-docker $REGION-docker.pkg.dev

cd ~/cloud-code-samples/java/java-hello-world

docker build -t "$REGION"-docker.pkg.dev/"$PROJECT_ID"/container-dev-repo/java-hello-world:tag1 .

docker push "$REGION"-docker.pkg.dev/"$PROJECT_ID"/container-dev-repo/java-hello-world:tag1


