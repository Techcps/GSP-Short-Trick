

gcloud services enable documentai.googleapis.com --project=$DEVSHELL_PROJECT_ID

echo "--------------------------"

echo "Click this link to open Document AI [https://console.cloud.google.com/ai/document-ai?referrer=search&cloudshell=true&project=$DEVSHELL_PROJECT_ID]..."

echo "--------------------------"

echo "Click here to Download the form.pdf file to your local machine [https://storage.googleapis.com/cloud-training/document-ai/generic/form.pdf]..."


echo "------------Please like share and subscribe to Techcps [ https://www.youtube.com/@techcps ] --------------"


export ZONE=$(gcloud compute instances list document-ai-dev --format 'csv[no-heading](zone)')
gcloud compute ssh document-ai-dev --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet


