

gcloud auth list

gcloud services enable cloudscheduler.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud pubsub topics create cron-topic

gcloud pubsub subscriptions create cron-sub --topic cron-topic

