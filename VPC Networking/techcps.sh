
export REGION_1=${ZONE_1%-*}

export REGION_2=${ZONE_2%-*}

# Delete the all default network firewall rules
gcloud compute firewall-rules delete default-allow-rdp --quiet
gcloud compute firewall-rules delete default-allow-ssh --quiet
gcloud compute firewall-rules delete default-allow-internal --quiet
gcloud compute firewall-rules delete default-allow-icmp --quiet

# Delete the default VPC network
gcloud compute networks delete default --quiet

# Create an auto mode VPC network with firewall rules
gcloud compute networks create mynetwork --project=$DEVSHELL_PROJECT_ID --subnet-mode auto
gcloud compute firewall-rules create allow-all --network mynetwork --project=$DEVSHELL_PROJECT_ID --allow all

# Create a VM instance
gcloud compute instances create mynet-us-vm --zone=$ZONE_1 --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork --create-disk=auto-delete=yes,boot=yes,device-name=mynet-us-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE_1/diskTypes/pd-balanced

gcloud compute instances create mynet-eu-vm --zone=$ZONE_2 --project=$DEVSHELL_PROJECT_ID --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork --create-disk=auto-delete=yes,boot=yes,device-name=mynet-eu-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/us-east1-c/diskTypes/pd-balanced

# Convert the network to a custom mode network
gcloud compute networks update mynetwork --switch-to-custom-subnet-mode --project=$DEVSHELL_PROJECT_ID --quiet

# Create the managementnet network
gcloud compute networks create managementnet --subnet-mode custom
gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=$REGION_1 --range=10.240.0.0/20
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

# Create the privatenet network
gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=$REGION_1 --range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=$REGION_2 --range=172.20.0.0/20

gcloud compute networks list

# Create the firewall rules for managementnet
gcloud compute networks subnets list --sort-by=NETWORK
gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --network=managementnet --allow=tcp:22,tcp:3389,icmp --source-ranges=0.0.0.0/0

# Create the firewall rules for privatenet
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules list --sort-by=NETWORK

# Create the managementnet-us-vm instance
gcloud compute instances create managementnet-us-vm --zone=$ZONE_1 --machine-type=e2-micro --boot-disk-size=10GB --boot-disk-type=pd-standard --image-family=debian-11 --image-project=debian-cloud --network=managementnet --subnet=managementsubnet-us

# Create the privatenet-us-vm instance
gcloud compute instances create privatenet-us-vm --zone=$ZONE_1 --machine-type=e2-micro --subnet=privatesubnet-us --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=privatenet-us-vm

gcloud compute instances list --sort-by=ZONE

