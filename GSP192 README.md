
# Dataflow: Qwik Start - Templates [GSP192]

# If you consider that the video helped you to complete your lab, so please do like and subscribe. https://www.youtube.com/@techcps

Click Activate Cloud Shell Activate Cloud Shell icon at the top of the Google Cloud console

## Go to Task 3. Run the pipeline
* Copy Region

```
export REGION=
```
```
gcloud auth list
gcloud config list project
gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com
bq mk taxirides
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime
gsutil mb gs://$DEVSHELL_PROJECT_ID/
sleep 45
```
```
gcloud dataflow jobs run iotflow \
--gcs-location gs://dataflow-templates/latest/PubSub_to_BigQuery \
--region $REGION \
--staging-location gs://$DEVSHELL_PROJECT_ID/temp \
--parameters inputTopic=projects/pubsub-public-data/topics/taxirides-realtime,outputTableSpec=$DEVSHELL_PROJECT_ID:taxirides.realtime
```

# Congratulations, you're all done with the lab 😄
# Thanks for watching :)
