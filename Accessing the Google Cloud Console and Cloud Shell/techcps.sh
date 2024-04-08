
gcloud auth list
export REGION="${ZONE%-*}"

gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID

gsutil uniformbucketlevelaccess set off gs://$DEVSHELL_PROJECT_ID

gcloud compute instances create first-vm --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --tags=http-server

gcloud iam service-accounts create test-service-account --display-name="test-service-account"

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member serviceAccount:test-service-account@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role roles/editor


