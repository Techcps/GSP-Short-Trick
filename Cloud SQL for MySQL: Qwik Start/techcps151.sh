
gcloud auth list

gcloud config set compute/zone $ZONE

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

gcloud sql instances create myinstance --project=$DEVSHELL_PROJECT_ID --region=${ZONE%-*} --root-password=techcps --tier=db-n1-standard-4 --database-version=MYSQL_8_0

gcloud sql databases create guestbook --instance=myinstance

echo "Congratulations, you're all done with the lab"
echo "Please like share and subscribe to techcps(https://www.youtube.com/@techcps)..."


