
export REGION_1=${ZONE_1%-*}

export REGION_2=${ZONE_2%-*}

# Delete the all default network firewall rules
gcloud compute firewall-rules delete default-allow-icmp --quiet
gcloud compute firewall-rules delete default-allow-rdp --quiet
gcloud compute firewall-rules delete default-allow-ssh --quiet
gcloud compute firewall-rules delete default-allow-internal --quiet

# Delete the default VPC network
gcloud compute networks delete default --quiet

# Create an auto mode VPC network with firewall rules
gcloud compute networks create mynetwork --project=$DEVSHELL_PROJECT_ID --subnet-mode auto
gcloud compute firewall-rules create allow-all --network mynetwork --project=$DEVSHELL_PROJECT_ID --allow all

# Create a VM instance
gcloud compute instances create mynet-us-vm --zone=$ZONE_1 --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork --create-disk=auto-delete=yes,boot=yes,device-name=mynet-us-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE_1/diskTypes/pd-balanced

gcloud compute instances create mynet-eu-vm --zone=$ZONE_2 --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork --create-disk=auto-delete=yes,boot=yes,device-name=mynet-eu-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/us-east1-c/diskTypes/pd-balanced

