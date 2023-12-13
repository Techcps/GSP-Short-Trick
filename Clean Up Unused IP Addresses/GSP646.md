
# Clean Up Unused IP Addresses [GSP646]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
export REGION=
```

```
gcloud auth list
gcloud config list project
gcloud services enable cloudscheduler.googleapis.com
git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/
export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
export region=Region
WORKDIR=$(pwd)
cd $WORKDIR/unused-ip
export USED_IP=used-ip-address
export UNUSED_IP=unused-ip-address
gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=Region
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=Region
gcloud compute addresses list --filter="region:(Region)"
export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=Region --format=json | jq -r '.address')
gcloud compute instances create static-ip-instance \
--zone=Zone \
--machine-type=e2-medium \
--subnet=default \
--address=$USED_IP_ADDRESS
gcloud compute addresses list --filter="region:(Region)"
cat $WORKDIR/unused-ip/function.js | grep "const compute" -A 31
gcloud functions deploy unused_ip_function --trigger-http --runtime=nodejs12 --region=Region
export FUNCTION_URL=$(gcloud functions describe unused_ip_function --region=Region --format=json | jq -r '.httpsTrigger.url')
gcloud app create --region REGION
gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=Region
gcloud scheduler jobs run unused-ip-job \
--location=Region
gcloud compute addresses list --filter="region:(Region)"
```


# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
