

PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID=$DEVSHELL_PROJECT_ID

echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

gcloud services enable cloudbuild.googleapis.com cloudfunctions.googleapis.com run.googleapis.com logging.googleapis.com storage-component.googleapis.com aiplatform.googleapis.com

sleep 30

gcloud auth list


git clone https://github.com/Techcps/GSP-Short-Trick.git

cd GSP-Short-Trick/Develop\ an\ App\ with\ Vertex\ AI\ Gemini\ 1.0\ Pro

cd gemini-app

sleep 10

pip install -r requirements.txt


python3 -m venv gemini-streamlit


source gemini-streamlit/bin/activate

sleep 10

echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"


SERVICE_NAME='gemini-app-playground' # Name of your Cloud Run service.
AR_REPO='gemini-app-repo'            # Name of your repository in Artifact Registry that stores your application container image.
echo "SERVICE_NAME=${SERVICE_NAME}"
echo "AR_REPO=${AR_REPO}"


gcloud artifacts repositories create "$AR_REPO" --location="$REGION" --repository-format=Docker

gcloud auth configure-docker "$REGION-docker.pkg.dev"


cat > Dockerfile <<EOF_CP
FROM python:3.8

EXPOSE 8080
WORKDIR /app

COPY . ./

RUN pip install -r requirements.txt

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]

EOF_CP


gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME"


#!/bin/bash

deploy_function() {
gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$PROJECT_ID \
  --set-env-vars=PROJECT_ID=$PROJECT_ID,REGION=$REGION
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully!"
    deploy_success=true
  else
    echo "Retrying, please subscribe to techcps[https://www.youtube.com/@techcps]."
    sleep 10
  fi
done  

