

# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE

# Export variables after collecting input
export ZONE

export location=$ZONE

gcloud services enable \
  compute.googleapis.com \
  monitoring.googleapis.com \
  logging.googleapis.com \
  notebooks.googleapis.com \
  aiplatform.googleapis.com \
  artifactregistry.googleapis.com \
  container.googleapis.com


gcloud notebooks instances create cnn-challenge \
--location=$ZONE --machine-type=e2-standard-2 \
--vm-image-project=deeplearning-platform-release \
--vm-image-family=tf-2-11-cu113-notebooks


