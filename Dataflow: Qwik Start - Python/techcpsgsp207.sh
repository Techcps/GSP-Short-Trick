

export PROJECT_ID=$(gcloud config get-value project)
export BUCKET_NAME=$PROJECT_ID

gcloud config set compute/region $REGION

gcloud services disable dataflow.googleapis.com

gcloud services enable dataflow.googleapis.com

gcloud storage buckets create gs://$BUCKET_NAME --project=$PROJECT_ID --location=us

docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID python:3.9 /bin/bash

pip install 'apache-beam[gcp]'==2.42.0

python -m apache_beam.examples.wordcount --output OUTPUT_FILE

cat $(ls)

BUCKET=gs://$PROJECT_ID

python -m apache_beam.examples.wordcount --project $DEVSHELL_PROJECT_ID --runner DataflowRunner --staging_location $BUCKET/staging --temp_location $BUCKET/temp --output $BUCKET/results/output --region $REGION

