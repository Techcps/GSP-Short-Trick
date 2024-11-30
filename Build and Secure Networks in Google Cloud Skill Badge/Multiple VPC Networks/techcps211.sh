

# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE
read -p "${YELLOW}${BOLD}Enter the REGION_2: ${RESET}" REGION_2

export ZONE REGION_2

export REGION="${ZONE%-*}"

export PROJECT_ID=$(gcloud config get-value project)

gcloud compute networks create managementnet --subnet-mode=custom

gcloud compute networks subnets create managementsubnet-1 --network=managementnet --region=$REGION --range=10.130.0.0/20

gcloud compute networks create privatenet --subnet-mode=custom

gcloud compute networks subnets create privatesubnet-1 --network=privatenet --region=$REGION --range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-2 --network=privatenet --region=$REGION_2 --range=172.20.0.0/20

gcloud compute networks list

gcloud compute networks subnets list --sort-by=NETWORK

gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules list --sort-by=NETWORK

gcloud compute instances create managementnet-vm-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-micro --subnet=managementsubnet-1

gcloud compute instances create privatenet-vm-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-micro --subnet=privatesubnet-1

gcloud compute instances create vm-appliance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=privatesubnet-1 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=managementsubnet-1 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork

