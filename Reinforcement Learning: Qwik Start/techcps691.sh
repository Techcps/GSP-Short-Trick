

gcloud services enable aiplatform.googleapis.com storage-component.googleapis.com dataflow.googleapis.com artifactregistry.googleapis.com dataplex.googleapis.com compute.googleapis.com dataform.googleapis.com notebooks.googleapis.com datacatalog.googleapis.com visionai.googleapis.com 

sleep 30


# Create a new notebook instance
gcloud notebooks instances create my-notebook  --location=$ZONE --vm-image-project=deeplearning-platform-release --vm-image-family=tf-2-11-cu113-notebooks --machine-type=e2-standard-2

echo "Please subscribe to Techcps [https://www.youtube.com/@techcps].."

echo "----------------Click the link below------------------"

echo "Click the link on here https://console.cloud.google.com/vertex-ai/workbench/user-managed?cloudshell=true&project=$DEVSHELL_PROJECT_ID"


