
gcloud auth list

gcloud config set compute/region $REGION

gcloud sql instances create myinstance --database-version=POSTGRES_15 --tier=db-custom-2-7680 --region=$REGION --storage-type=SSD --storage-size=250GB
