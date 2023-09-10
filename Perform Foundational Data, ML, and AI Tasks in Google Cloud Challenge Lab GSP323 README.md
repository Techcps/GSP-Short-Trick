
# Perform Foundational Data, ML, and AI Tasks in Google Cloud: Challenge Lab [GSP323]


* Enter your DATASET_NAME
```
bq mk 
```

* Enter your BUCKET_NAME
```
gsutil mb gs://
```
```
gsutil cp gs://cloud-training/gsp323/lab.csv  .  
gsutil cp gs://cloud-training/gsp323/lab.schema .
cat lab.schema
```

```
export API_KEY=
```
```
export BUCKET_3=
```
```
export BUCKET_4=
```
```
gcloud iam service-accounts create techcps \
  --display-name "my natural language service account"
gcloud iam service-accounts keys create ~/key.json \
  --iam-account techcps@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS="/home/$USER/key.json"
gcloud auth activate-service-account techcps@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --key-file=$GOOGLE_APPLICATION_CREDENTIALS
gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat." > result.json
gcloud auth login --no-launch-browser
```
```
gsutil cp result.json $BUCKET_4

cat > request.json <<EOF 
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-training/gsp323/task3.flac"
  }
}
EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
gsutil cp result.json $BUCKET_3
gcloud iam service-accounts create quickstart
gcloud iam service-accounts keys create key.json --iam-account quickstart@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
gcloud auth activate-service-account --key-file key.json
export ACCESS_TOKEN=$(gcloud auth print-access-token)
cat > request.json <<EOF 
{
   "inputUri":"gs://spls/gsp154/video/train.mp4",
   "features": [
       "TEXT_DETECTION"
   ]
}
EOF

curl -s -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @request.json

curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer $ACCESS_TOKEN" 'https://videointelligence.googleapis.com/v1/operations/OPERATION_FROM_PREVIOUS_REQUEST' > result1.json
```

# Congratulations, you're all done with the lab 😄
# If you consider that the video helped you to complete your lab, so please do like and subscribe
# Thanks for watching :)
