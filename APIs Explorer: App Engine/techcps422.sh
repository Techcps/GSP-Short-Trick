

# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION

# Export variables after collecting input
export REGION

echo "REGION=${REGION}"

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

gcloud services enable appengine.googleapis.com

git clone https://github.com/GoogleCloudPlatform/python-docs-samples

cd ~/python-docs-samples/appengine/standard_python3/hello_world

export "PROJECT_ID=${PROJECT_ID}"

gcloud app create --project $PROJECT_ID --region=$REGION

echo "Y" | gcloud app deploy app.yaml --project $PROJECT_ID

cd ~/python-docs-samples/appengine/standard_python3/hello_world

echo "Y" | gcloud app deploy -v v1


