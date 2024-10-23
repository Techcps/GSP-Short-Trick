
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

gcloud compute instances create $VM_NAME \
--zone=$ZONE --project=$DEVSHELL_PROJECT_ID \
--machine-type=f1-micro \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
--metadata=startup-script='#!/bin/bash
  apt-get update
  apt-get install apache2 -y
  systemctl start apache2
  systemctl enable apache2' \
--tags=http-server,https-server \
--create-disk=auto-delete=yes,boot=yes,device-name=$VM_NAME,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240312,mode=rw,size=10,type=pd-balanced \
--no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring \
--reservation-affinity=any

gcloud compute firewall-rules create allow-http --action=ALLOW --direction=INGRESS --target-tags=http-server --source-ranges=0.0.0.0/0 --rules=tcp:80 --description="Allow incoming HTTP traffic"


IP_CP=$(gcloud compute instances list --filter="name=('$VM_NAME')" --zones="$ZONE" --format='value(EXTERNAL_IP)')


curl http://$IP_CP
