

echo "Please export the values correctly."

read -p "Enter custom_metric: " custom_metric
read -p "Enter VALUE: " VALUE

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud services enable monitoring.googleapis.com --project="$DEVSHELL_PROJECT_ID"

ZONE=$(gcloud compute instances list --project="$DEVSHELL_PROJECT_ID" --format="get(zone)" --limit=1)

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

INSTANCE_ID=$(gcloud compute instances describe video-queue-monitor --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --format="get(id)")

gcloud compute instances stop video-queue-monitor --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE"

cat > startup-script.sh <<EOF_CP
#!/bin/bash

ZONE="$ZONE"
REGION="${ZONE%-*}"
PROJECT_ID="$DEVSHELL_PROJECT_ID"

echo "ZONE: $ZONE"
echo "REGION: $REGION"
echo "PROJECT_ID: $PROJECT_ID"

sudo apt update && sudo apt -y
sudo apt-get install wget -y
sudo apt-get -y install git
sudo chmod 777 /usr/local/
sudo wget https://go.dev/dl/go1.22.8.linux-amd64.tar.gz 
sudo tar -C /usr/local -xzf go1.22.8.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo service google-cloud-ops-agent start

mkdir /work
mkdir /work/go
mkdir /work/go/cache
export GOPATH=/work/go
export GOCACHE=/work/go/cache

cd /work/go
mkdir video
gsutil cp gs://spls/gsp338/video_queue/main.go /work/go/video/main.go

go get go.opencensus.io
go get contrib.go.opencensus.io/exporter/stackdriver

# Set project metadata
export MY_PROJECT_ID="$DEVSHELL_PROJECT_ID"
export MY_GCE_INSTANCE_ID="$INSTANCE_ID"
export MY_GCE_INSTANCE_ZONE="$ZONE"

cd /work
go mod init go/video/main
go mod tidy
go run /work/go/video/main.go
EOF_CP


gcloud compute instances add-metadata video-queue-monitor --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --metadata-from-file startup-script=startup-script.sh && gcloud compute instances start video-queue-monitor --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" && gcloud compute instances start video-queue-monitor --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE"


gcloud logging metrics create $custom_metric \
    --description="Metric for high resolution video uploads" \
    --log-filter='textPayload=("file_format=4K" OR "file_format=8K")'


cat > email-channel.json <<EOF_CP
{
  "type": "email",
  "displayName": "techcps",
  "description": "Subscribe to techcps",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_CP

gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"

cp_info=$(gcloud beta monitoring channels list)
cp_id=$(echo "$cp_info" | grep -oP 'name: \K[^ ]+' | head -n 1)

cat > techcps.json <<EOF_CP
{
  "displayName": "techcps",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - logging/user/large_video_upload_rate",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"logging.googleapis.com/user/$custom_metric\"",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": $VALUE
      }
    }
  ],
  "alertStrategy": {
    "notificationPrompts": [
      "OPENED"
    ]
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$cp_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_CP


gcloud alpha monitoring policies create --policy-from-file=techcps.json
