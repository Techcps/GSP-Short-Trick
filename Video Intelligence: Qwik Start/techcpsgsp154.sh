
gcloud auth list
gcloud config list project

gcloud iam service-accounts create quickstart

gcloud iam service-accounts keys create key.json --iam-account quickstart@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

gcloud auth activate-service-account --key-file key.json
gcloud auth print-access-token

cat > request.json <<EOF_END
{
   "inputUri":"gs://spls/gsp154/video/train.mp4",
   "features": [
       "LABEL_DETECTION"
   ]
}
EOF_END

curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$(gcloud auth print-access-token)'' \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @request.json
    
curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$(gcloud auth print-access-token)'' \
    'https://videointelligence.googleapis.com/v1/projects/PROJECTS/locations/LOCATIONS/operations/OPERATION_NAME'
