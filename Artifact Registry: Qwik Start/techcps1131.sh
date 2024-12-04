
# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION


export PROJECT_ID=$(gcloud config get-value project)

gcloud artifacts repositories create example-docker-repo --repository-format=docker \
    --location=$REGION --description="Docker repository" \
    --project=$PROJECT_ID

gcloud artifacts repositories list \
    --project=$PROJECT_ID


gcloud auth configure-docker $REGION-docker.pkg.dev

docker pull us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0


docker tag us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0 \
$REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

docker push $REGION-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

