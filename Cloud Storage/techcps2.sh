
export REGION=${ZONE%-*}

gsutil mb -p $PROJECT_ID_2 -c STANDARD -l $REGION -b on gs://$PROJECT_ID_2

gsutil uniformbucketlevelaccess set off gs://$PROJECT_ID_2
echo "please like share and subscribe to techcps" > test.txt
gsutil cp test.txt gs://$PROJECT_ID_2

gcloud iam service-accounts create cross-project-storage --display-name "Cross-Project Storage" --description="please like share and subscribe to techcps"

gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member="serviceAccount:cross-project-storage@$PROJECT_ID_2.iam.gserviceaccount.com" --role="roles/storage.objectViewer"
gcloud projects add-iam-policy-binding $PROJECT_ID_2 --member="serviceAccount:cross-project-storage@$PROJECT_ID_2.iam.gserviceaccount.com" --role="roles/storage.objectAdmin"
gcloud iam service-accounts keys create credentials.json --iam-account=cross-project-storage@$PROJECT_ID_2.iam.gserviceaccount.com

