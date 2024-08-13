

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID=$DEVSHELL_PROJECT_ID


export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')
gcloud config set project $DEVSHELL_PROJECT_ID

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  storage.googleapis.com \
  pubsub.googleapis.com

sleep 30

mkdir app && cd app

gsutil cp gs://cloud-training/CBL515/sample-apps/sample-node-app.zip . && unzip sample-node-app

cd sample-node-app

npm install

timeout 15  npm start


gcloud artifacts repositories create my-repo --project=$DEVSHELL_PROJECT_ID --repository-format=docker --location=$REGION --description="subscribe to techcps"

gcloud auth configure-docker $REGION-docker.pkg.dev

REPO=${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repo

cat > cloudbuild.yaml <<EOF
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', '${REPO}/sample-node-app-image', '.' ]
images:
- '${REPO}/sample-node-app-image'
EOF

gcloud builds submit --region=$REGION --config=cloudbuild.yaml

deploy_function() {
gcloud run deploy sample-node-app --image ${REPO}/sample-node-app-image --region $REGION --allow-unauthenticated
}


deploy_success=false

while [ "$deploy_success" = false ]; do
    if deploy_function; then
        echo "Function deployed successfully."
        deploy_success=true
    else
        echo "Retrying in 10 seconds, Please subscribe to techcps:(https://www.youtube.com/@techcps)"
        sleep 10
    fi
done



URL=$(gcloud run services list --format='value(URL)')


curl $URL/service/products | jq

sleep 30

curl $URL/service/products | jq


