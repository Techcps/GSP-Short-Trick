

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="json" | jq -r '.projectNumber')

bq mk $DATASET_NAME

gsutil mb gs://$BUCKET_CP1


gsutil cp gs://cloud-training/gsp323/lab.csv  .
  
gsutil cp gs://cloud-training/gsp323/lab.schema .
 
cat lab.schema


echo '[
    {"type":"STRING","name":"guid"},
    {"type":"BOOLEAN","name":"isActive"},
    {"type":"STRING","name":"firstname"},
    {"type":"STRING","name":"surname"},
    {"type":"STRING","name":"company"},
    {"type":"STRING","name":"email"},
    {"type":"STRING","name":"phone"},
    {"type":"STRING","name":"address"},
    {"type":"STRING","name":"about"},
    {"type":"TIMESTAMP","name":"registered"},
    {"type":"FLOAT","name":"latitude"},
    {"type":"FLOAT","name":"longitude"}
]' > lab.schema


bq mk --table $DATASET_NAME.$TABLE_NAME lab.schema


gcloud dataflow jobs run techcps --gcs-location gs://dataflow-templates-$REGION/latest/GCS_Text_to_BigQuery --worker-machine-type e2-standard-2 --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID-marking/temp --parameters inputFilePattern=gs://cloud-training/gsp323/lab.csv,JSONPath=gs://cloud-training/gsp323/lab.schema,outputTable=$DEVSHELL_PROJECT_ID:$DATASET_NAME.$TABLE_NAME,bigQueryLoadingTemporaryDirectory=gs://$DEVSHELL_PROJECT_ID-marking/bigquery_temp,javascriptTextTransformGcsPath=gs://cloud-training/gsp323/lab.js,javascriptTextTransformFunctionName=transform



gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member "serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" --role "roles/storage.admin"


gcloud compute networks subnets update default --region $REGION --enable-private-ip-google-access



gcloud iam service-accounts create techcps --display-name "my natural language service account"

gcloud iam service-accounts keys create ~/key.json --iam-account techcps@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="/home/$USER/key.json"

gcloud auth activate-service-account techcps@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --key-file=$GOOGLE_APPLICATION_CREDENTIALS

gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat." > result.json



gcloud auth login --no-launch-browser --quiet


gsutil cp result.json $BUCKET_CP4


cat > request.json <<EOF_CP
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-training/gsp323/task3.flac"
  }
}
EOF_CP



curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json



gsutil cp result.json $BUCKET_CP3

gcloud iam service-accounts create cpfamily

gcloud iam service-accounts keys create key.json --iam-account cpfamily@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

gcloud auth activate-service-account --key-file key.json


ACCESS_TOKEN=$(gcloud auth print-access-token)


cat > request.json <<EOF_CP 
{
   "inputUri":"gs://spls/gsp154/video/train.mp4",
   "features": [
       "TEXT_DETECTION"
   ]
}
EOF_CP




curl -s -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @request.json




curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer $ACCESS_TOKEN" 'https://videointelligence.googleapis.com/v1/operations/OPERATION_FROM_PREVIOUS_REQUEST' > result1.json


