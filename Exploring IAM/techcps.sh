

gcloud auth list
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gsutil mb -l us gs://$PROJECT_ID

curl -O https://github.com/Techcps/GSP-Short-Trick/blob/main/Exploring%20IAM/sample.txt

gsutil cp sample.txt gs://$PROJECT_ID

gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USERNAME_2 --role=roles/viewer

gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USERNAME_2 --role=roles/storage.objectViewer

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectViewer"

gcloud iam service-accounts create read-bucket-objects --description="please like share & subscribe to techcps" --display-name="read-bucket-objects"

gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com --member=domain:altostrat.com --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT_ID --member=domain:altostrat.com --role=roles/compute.instanceAdmin.v1

gcloud compute instances create demoiam --zone=$ZONE --machine-type e2-micro --image-family debian-11 --image-project debian-cloud --service-account read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com

