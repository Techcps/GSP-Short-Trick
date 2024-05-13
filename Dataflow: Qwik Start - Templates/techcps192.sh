


gcloud services disable dataflow.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud services enable dataflow.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 30

bq mk taxirides

bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime

gsutil mb gs://$DEVSHELL_PROJECT_ID/

sleep 30


#!/bin/bash

while true; do
    gcloud dataflow jobs run iotflow \
        --gcs-location gs://dataflow-templates-"$REGION"/latest/PubSub_to_BigQuery \
        --region "$REGION" \
        --worker-machine-type e2-medium \
        --staging-location gs://"$DEVSHELL_PROJECT_ID"/temp \
        --parameters inputTopic=projects/pubsub-public-data/topics/taxirides-realtime,outputTableSpec="Table Name":taxirides.realtime

    # Check the gcloud dataflow jobs
    if [ $? -eq 0 ]; then
        echo "Dataflow job completed and running successfully."
        break
    else
        echo "Dataflow job failed. Please subscribe to techcps (https://www.youtube.com/@techcps).."
        sleep 30
    fi
done



