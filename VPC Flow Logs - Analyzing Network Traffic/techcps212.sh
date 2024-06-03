

export REGION="${ZONE%-*}"


gcloud compute networks create vpc-net --project=$DEVSHELL_PROJECT_ID --description="Subscribe to Techcps" --subnet-mode=custom


gcloud compute networks subnets create vpc-subnet --project=$DEVSHELL_PROJECT_ID --network=vpc-net --region=$REGION --range=10.1.3.0/24 --enable-flow-logs


sleep 15


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create allow-http-ssh --direction=INGRESS --priority=1000 --network=vpc-net --action=ALLOW --rules=tcp:80,tcp:22 --source-ranges=0.0.0.0/0 --target-tags=http-server


gcloud compute instances create web-server --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --subnet=vpc-subnet --network=vpc-net --tags=http-server --image-family=debian-10 --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
        sudo apt update
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2' \
    --labels=server=apache


gcloud compute firewall-rules create allow-http \
    --allow=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server \
    --description="Allow HTTP traffic"


bq mk bq_vpcflows


CP_IP=$(gcloud compute instances describe web-server --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

export MY_SERVER=$CP_IP

for ((i=1;i<=50;i++)); do curl $MY_SERVER; done


echo "Open Firewall link"
echo "https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/allow-http-ssh?project=$DEVSHELL_PROJECT_ID"

echo "Open Sink link"
echo "https://console.cloud.google.com/logs/query;query=resource.type%3D%22gce_subnetwork%22%0Alog_name%3D%22projects%2F$DEVSHELL_PROJECT_ID%2Flogs%2Fcompute.googleapis.com%252Fvpc_flows%22;cursorTimestamp=2024-06-03T07:20:00.734122029Z;duration=PT1H?project=$DEVSHELL_PROJECT_ID"




