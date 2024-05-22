

export REGION="${ZONE%-*}"

# Disable Dataflow API
gcloud services disable dataflow.googleapis.com

# Enable Dataflow API
gcloud services enable dataflow.googleapis.com


gcloud bigtable instances tables create UserSessions --project=$DEVSHELL_PROJECT_ID --instance=personalized-sales --column-families=Interactions,Sales

gsutil mb -l US gs://$DEVSHELL_PROJECT_ID

sleep 60


#!/bin/bash

deploy_function() {
  gcloud dataflow jobs run import-usersessions \
    --region=$REGION \
    --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable \
    --staging-location gs://$DEVSHELL_PROJECT_ID/temp \
    --parameters bigtableProject=$DEVSHELL_PROJECT_ID,bigtableInstanceId=personalized-sales,bigtableTableId=UserSessions,sourcePattern=gs://cloud-training/OCBL377/retail-interactions-sales-00000-of-00001,mutationThrottleLatencyMs=0
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully. (https://www.youtube.com/@techcps)"
    deploy_success=true
  else
    echo "Deployment Retrying, please subscribe to techcps (https://www.youtube.com/@techcps).."
    sleep 10
  fi
done




echo project = `gcloud config get-value project` \
    >> ~/.cbtrc

echo instance = personalized-sales \
    >> ~/.cbtrc

cat ~/.cbtrc


