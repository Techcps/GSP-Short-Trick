
gcloud auth list

gcloud config set compute/region $REGION
gcloud services enable pubsublite.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 25

pip3 install --upgrade google-cloud-pubsublite

gcloud pubsub lite-topics create my-lite-topic --project=$DEVSHELL_PROJECT_ID --zone=$REGION-b --partitions=1 --per-partition-bytes=30GiB --message-retention-period=2w

gcloud pubsub lite-subscriptions create my-lite-subscription --project=$DEVSHELL_PROJECT_ID --zone=$REGION-b --topic=my-lite-topic --delivery-requirement=deliver-after-stored

