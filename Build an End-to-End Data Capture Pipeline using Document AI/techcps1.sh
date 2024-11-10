

gcloud auth list

gcloud services enable documentai.googleapis.com      
gcloud services enable cloudfunctions.googleapis.com  
gcloud services enable cloudbuild.googleapis.com    
gcloud services enable geocoding-backend.googleapis.com   

gcloud alpha services api-keys create --display-name="techcps" --project=$DEVSHELL_PROJECT_ID

echo ""

echo "Click this link to open[https://console.cloud.google.com/apis/credentials?cloudshell=true&project=$DEVSHELL_PROJECT_ID]"

