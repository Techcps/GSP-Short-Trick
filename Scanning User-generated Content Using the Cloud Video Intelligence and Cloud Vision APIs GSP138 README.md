
# Scanning User-generated Content Using the Cloud Video Intelligence and Cloud Vision APIs [GSP138]

* In the GCP Console open the Cloud Shell and enter the following commands:

```
gcloud auth list
gcloud config list project
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export IV_BUCKET_NAME=${PROJECT_ID}-upload
export FILTERED_BUCKET_NAME=${PROJECT_ID}-filtered
export FLAGGED_BUCKET_NAME=${PROJECT_ID}-flagged
export STAGING_BUCKET_NAME=${PROJECT_ID}-staging
gsutil mb gs://${IV_BUCKET_NAME}
gsutil mb gs://${FILTERED_BUCKET_NAME}
gsutil mb gs://${FLAGGED_BUCKET_NAME}
gsutil mb gs://${STAGING_BUCKET_NAME}
gsutil ls
export UPLOAD_NOTIFICATION_TOPIC=upload_notification
gcloud pubsub topics create ${UPLOAD_NOTIFICATION_TOPIC}
gcloud pubsub topics create visionapiservice
gcloud pubsub topics create videointelligenceservice
gcloud pubsub topics create bqinsert
gcloud pubsub topics list
gsutil notification create -t upload_notification -f json -e OBJECT_FINALIZE gs://${IV_BUCKET_NAME}
gsutil notification list gs://${IV_BUCKET_NAME}
gsutil -m cp -r gs://spls/gsp138/cloud-functions-intelligentcontent-nodejs .
cd cloud-functions-intelligentcontent-nodejs
export DATASET_ID=intelligentcontentfilter
export TABLE_NAME=filtered_content

bq --project_id ${PROJECT_ID} mk ${DATASET_ID}
bq --project_id ${PROJECT_ID} mk --schema intelligent_content_bq_schema.json -t ${DATASET_ID}.${TABLE_NAME}
bq --project_id ${PROJECT_ID} show ${DATASET_ID}.${TABLE_NAME}
sed -i "s/\[PROJECT-ID\]/$PROJECT_ID/g" config.json
sed -i "s/\[FLAGGED_BUCKET_NAME\]/$FLAGGED_BUCKET_NAME/g" config.json
sed -i "s/\[FILTERED_BUCKET_NAME\]/$FILTERED_BUCKET_NAME/g" config.json
sed -i "s/\[DATASET_ID\]/$DATASET_ID/g" config.json
sed -i "s/\[TABLE_NAME\]/$TABLE_NAME/g" config.json
gcloud functions deploy GCStoPubsub --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic ${UPLOAD_NOTIFICATION_TOPIC} --entry-point GCStoPubsub --region us-central1
gcloud functions deploy visionAPI --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic visionapiservice --entry-point visionAPI --region us-central1
gcloud functions deploy videoIntelligenceAPI --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic videointelligenceservice --entry-point videoIntelligenceAPI --timeout 540 --region us-central1
gcloud functions deploy insertIntoBigQuery --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic bqinsert --entry-point insertIntoBigQuery --region us-central1
gcloud beta functions list

```

# Upload an image and a video file to the upload storage bucket
* On the Navigation menu (Navigation menu icon), click Cloud Storage > Buckets.
* Click the name of the bucket with the -upload suffix and then click Upload Files.
* Upload some image files from your local machine.

```
gcloud beta functions logs read --filter "finished with status" "GCStoPubsub" --limit 100 --region us-central1
gcloud beta functions logs read --filter "finished with status" "insertIntoBigQuery" --limit 100 --region us-central1
echo "
#standardSql

SELECT insertTimestamp,
  contentUrl,
  flattenedSafeSearch.flaggedType,
  flattenedSafeSearch.likelihood
FROM \`$PROJECT_ID.$DATASET_ID.$TABLE_NAME\`
CROSS JOIN UNNEST(safeSearch) AS flattenedSafeSearch
ORDER BY insertTimestamp DESC,
  contentUrl,
  flattenedSafeSearch.flaggedType
LIMIT 1000
" > sql.txt
bq --project_id ${PROJECT_ID} query < sql.txt
```





# Congratulations, you're all done with the lab 😄
# If you consider that the video helped you to complete your lab, so please do like and subscribe
# Thanks for watching :)