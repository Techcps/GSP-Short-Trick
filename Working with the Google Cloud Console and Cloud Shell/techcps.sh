
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET_NAME=$PROJECT_ID

gsutil mb gs://$PROJECT_ID

gcloud storage buckets create gs://$PROJECT_ID-BUCKET

curl -O https://github.com/Techcps/GSP-Short-Trick/blob/main/Cloud%20Storage%3A%20Qwik%20Start%20-%20Cloud%20Console/kitten.png

gsutil cp kitten.png gs://$PROJECT_ID-BUCKET/kitten.png

