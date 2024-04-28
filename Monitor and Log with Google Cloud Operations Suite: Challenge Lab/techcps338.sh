

gcloud services enable monitoring.googleapis.com --project=$DEVSHELL_PROJECT_ID

ZONE=$(gcloud compute instances list --project="$DEVSHELL_PROJECT_ID" --format="get(zone)" --limit=1)

instance_id=$(gcloud compute instances describe video-queue-monitor --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --format="get(id)")


gcloud compute instances add-metadata video-queue-monitor --metadata=startup-script="$(cat <<EOF_CP
#!/bin/bash
ZONE="$ZONE"
REGION="\${ZONE%-*}"
PROJECT_ID="$DEVSHELL_PROJECT_ID"


sudo apt update && sudo apt -y
sudo apt-get install wget -y
sudo apt-get -y install git
sudo chmod 777 /usr/local/
sudo wget https://go.dev/dl/go1.19.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.6.linux-amd64.tar.gz
export PATH=\$PATH:/usr/local/go/bin


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


export PROJECT_ID="$DEVSHELL_PROJECT_ID"
export INSTANCE_ID="$instance_id"
export INSTANCE_ZONE="$ZONE"


cd /work
go mod init go/video/main
go mod tidy
go run /work/go/video/main.go
EOF_CP
)" --zone=$ZONE

gcloud compute instances reset video-queue-monitor --zone=$ZONE --project=$DEVSHELL_PROJECT_ID



gcloud logging metrics create $custom_metric \
    --description="Metric for high resolution video uploads" \
    --log-filter='textPayload=("file_format=4K" OR "file_format=8K")'


