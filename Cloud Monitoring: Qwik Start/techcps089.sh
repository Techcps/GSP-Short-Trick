

gcloud auth list

gcloud config set project $DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE
export REGION="${ZONE%-*}"
gcloud config set compute/region $REGION


gcloud compute instances create lamp-1-vm --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --machine-type=e2-medium --image-project=debian-cloud --image-family=debian-12 --tags=http-server

gcloud compute firewall-rules create allow-http --project=$DEVSHELL_PROJECT_ID --network=default --action=ALLOW --direction=INGRESS --priority=1000 --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server


INSTANCE_CP=$(gcloud compute instances describe lamp-1-vm --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --format='json' | jq -r '.id')


gcloud monitoring uptime create lamp-uptime-check --resource-type="gce-instance" --resource-labels=project_id=$DEVSHELL_PROJECT_ID,instance_id=$INSTANCE_CP,zone=$ZONE


# Create the email notification channel JSON
cat > email.json <<EOF_CP
{
  "type": "email",
  "displayName": "techcps",
  "description": "subscribe to techcps",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_CP

# Create the notification channel
gcloud beta monitoring channels create --channel-content-from-file=email.json

# Get the channel info
channel_info=$(gcloud beta monitoring channels list)
channel_id=$(echo "$channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)

# Get the project ID
project_id=$(gcloud config get-value project)

# Create the JSON alert policy
cat > techcps-alert-policy.json <<EOF_CP
{
  "displayName": "Inbound Traffic Alert",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Network traffic",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/interface/traffic\"",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "thresholdValue": 1000,
        "duration": "0s"
      }
    }
  ],
  "notificationChannels": [
    "$channel_id"
  ],
  "combiner": "OR",
  "enabled": true
}
EOF_CP


# Create the alert policy
gcloud alpha monitoring policies create --policy-from-file="techcps-alert-policy.json"


gcloud compute ssh lamp-1-vm --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet --command="sudo apt-get update && sudo apt-get install apache2 php7.0 -y && sudo service apache2 restart && curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh && sudo bash add-google-cloud-ops-agent-repo.sh --also-install -y && sudo systemctl status google-cloud-ops-agent"*" && sudo apt-get update"



