

export REGION="${ZONE%-*}"


gcloud services disable dataflow.googleapis.com --project $DEVSHELL_PROJECT_ID

export PROJECT_ID=$(gcloud config get-value project)

gcloud services enable dataflow.googleapis.com --project $DEVSHELL_PROJECT_ID

sleep 10

gsutil mb gs://$PROJECT_ID

export PROJECT_ID=$(gcloud config get-value project)


gcloud bigtable instances tables create SessionHistory --instance=ecommerce-recommendations --project=$PROJECT_ID --column-families=Engagements,Sales



gcloud bigtable instances tables create PersonalizedProducts --project=$PROJECT_ID --instance=ecommerce-recommendations --column-families=Recommendations



gcloud beta bigtable backups create PersonalizedProducts_7 --instance=ecommerce-recommendations --cluster=ecommerce-recommendations-c1 --table=PersonalizedProducts --retention-period=7d 


gcloud beta bigtable instances tables restore --source=projects/$PROJECT_ID/instances/ecommerce-recommendations/clusters/ecommerce-recommendations-c1/backups/PersonalizedProducts_7 --async --destination=PersonalizedProducts_7_restored --destination-instance=ecommerce-recommendations --project=$PROJECT_ID


#!/bin/bash

while true; do
    gcloud dataflow jobs run import-sessions --region=$REGION --project=$PROJECT_ID --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable --staging-location gs://$PROJECT_ID/temp --parameters bigtableProject=$PROJECT_ID,bigtableInstanceId=ecommerce-recommendations,bigtableTableId=SessionHistory,sourcePattern=gs://cloud-training/OCBL377/retail-engagements-sales-00000-of-00001,mutationThrottleLatencyMs=0

    if [ $? -eq 0 ]; then
        echo "Job has completed successfully. subscribe to techcps(https://www.youtube.com/@techcps).."
        break
    else
        echo "Job failed. please like share and subscribe to techcps(https://www.youtube.com/@techcps)..."
        sleep 10
    fi
done


sleep 10

#!/bin/bash

while true; do
    gcloud dataflow jobs run import-recommendations --region=$REGION --project=$PROJECT_ID --gcs-location gs://dataflow-templates-$REGION/latest/GCS_SequenceFile_to_Cloud_Bigtable --staging-location gs://$PROJECT_ID/temp --parameters bigtableProject=$PROJECT_ID,bigtableInstanceId=ecommerce-recommendations,bigtableTableId=PersonalizedProducts,sourcePattern=gs://cloud-training/OCBL377/retail-recommendations-00000-of-00001,mutationThrottleLatencyMs=0

    if [ $? -eq 0 ]; then
        echo "Job has completed successfully. subscribe to techcps(https://www.youtube.com/@techcps).."
        break
    else
        echo "Job failed. please like share and subscribe to techcps(https://www.youtube.com/@techcps)..."
        sleep 10
    fi
done



sleep 180



