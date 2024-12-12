



# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)


echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE_1: ${RESET}" ZONE_1
read -p "${YELLOW}${BOLD}Enter the ZONE_2: ${RESET}" ZONE_2

# Export variables after collecting input
export ZONE_1 ZONE_2

export REGION_1="${ZONE_1%-*}"

export REGION_2="${ZONE_2%-*}"


gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")

gcloud compute networks delete default --quiet

gcloud compute networks create vpc-transit --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --bgp-routing-mode=global

# Task 1 is completed

gcloud compute networks create vpc-a --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --bgp-routing-mode=regional --mtu=1460 && gcloud compute networks subnets create vpc-a-sub1-use4 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --range=10.20.10.0/24 --stack-type=IPV4_ONLY --network=vpc-a

gcloud compute networks create vpc-b --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --bgp-routing-mode=regional --mtu=1460 && gcloud compute networks subnets create vpc-b-sub1-usw2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --range=10.20.20.0/24 --stack-type=IPV4_ONLY --network=vpc-b

# Task 2 is completed

gcloud compute routers create cr-vpc-transit-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --network=vpc-transit --asn=65000 && gcloud compute routers create cr-vpc-a-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --network=vpc-a --asn=65001

gcloud compute routers create cr-vpc-transit-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --network=vpc-transit --asn=65000 && gcloud compute routers create cr-vpc-b-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --network=vpc-b --asn=65002

gcloud compute vpn-gateways create vpc-transit-gw1-use4 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --network=vpc-transit && gcloud compute vpn-gateways create vpc-a-gw1-use4 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --network=vpc-a

gcloud compute vpn-gateways create vpc-transit-gw1-usw2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --network=vpc-transit && gcloud compute vpn-gateways create vpc-b-gw1-usw2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --network=vpc-b

# Task 3, Step 1, 2 is completed

gcloud compute vpn-tunnels create transit-to-vpc-a-tu1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --vpn-gateway=vpc-transit-gw1-use4 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-a-gw1-use4 --router=cr-vpc-transit-use4-1 --shared-secret=gcprocks --ike-version=2 --interface=0

gcloud compute vpn-tunnels create transit-to-vpc-a-tu2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --vpn-gateway=vpc-transit-gw1-use4 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-a-gw1-use4 --router=cr-vpc-transit-use4-1 --shared-secret=gcprocks --ike-version=2 --interface=1

gcloud compute routers add-interface cr-vpc-transit-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --interface-name=transit-to-vpc-a-tu1 --vpn-tunnel=transit-to-vpc-a-tu1 --ip-address=169.254.1.1 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --peer-name=transit-to-vpc-a-bgp1 --peer-asn=65001 --interface=transit-to-vpc-a-tu1 --advertisement-mode=custom --peer-ip-address=169.254.1.2

gcloud compute routers add-interface cr-vpc-transit-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --interface-name=transit-to-vpc-a-tu2 --vpn-tunnel=transit-to-vpc-a-tu2 --ip-address=169.254.1.5 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --peer-name=transit-to-vpc-a-bgp2 --peer-asn=65001 --interface=vpc-a-to-transit-tu2 --advertisement-mode=custom --peer-ip-address=169.254.1.6

gcloud compute vpn-tunnels create vpc-a-to-transit-tu1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --vpn-gateway=vpc-a-gw1-use4 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-transit-gw1-use4 --router=cr-vpc-a-use4-1 --ike-version=2 --shared-secret=gcprocks --interface=0

gcloud compute vpn-tunnels create vpc-a-to-transit-tu2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --vpn-gateway=vpc-a-gw1-use4 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-transit-gw1-use4 --router=cr-vpc-a-use4-1 --ike-version=2 --shared-secret=gcprocks --interface=1

gcloud compute routers add-interface cr-vpc-a-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --interface-name=vpc-a-to-transit-tu1 --vpn-tunnel=vpc-a-to-transit-tu1 --ip-address=169.254.1.2 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-a-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --peer-name=vpc-a-to-transit-bgp1 --peer-asn=65000 --interface=vpc-a-to-transit-tu1 --advertisement-mode=custom --peer-ip-address=169.254.1.1

gcloud compute routers add-interface cr-vpc-a-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --interface-name=vpc-a-to-transit-tu2 --vpn-tunnel=vpc-a-to-transit-tu2 --ip-address=169.254.1.6 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-a-use4-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --peer-name=vpc-a-to-transit-bgp2 --peer-asn=65000 --interface=vpc-a-to-transit-tu2 --advertisement-mode=custom --peer-ip-address=169.254.1.5
  
gcloud compute vpn-tunnels create transit-to-vpc-b-tu1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --vpn-gateway=vpc-transit-gw1-usw2 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-b-gw1-usw2 --router=cr-vpc-transit-usw2-1 --ike-version=2 --shared-secret=gcprocks --interface=0

gcloud compute vpn-tunnels create transit-to-vpc-b-tu2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --vpn-gateway=vpc-transit-gw1-usw2 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-b-gw1-usw2 --router=cr-vpc-transit-usw2-1 --ike-version=2 --shared-secret=gcprocks --interface=1

gcloud compute routers add-interface cr-vpc-transit-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --interface-name=transit-to-vpc-b-tu1 --vpn-tunnel=transit-to-vpc-b-tu1 --ip-address=169.254.1.9 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --peer-name=transit-to-vpc-b-bgp1 --peer-asn=65002 --interface=transit-to-vpc-b-tu1 --advertisement-mode=custom --peer-ip-address=169.254.1.10

gcloud compute routers add-interface cr-vpc-transit-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --interface-name=transit-to-vpc-b-tu2 --vpn-tunnel=transit-to-vpc-b-tu2 --ip-address=169.254.1.13 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --peer-name=transit-to-vpc-b-bgp2 --peer-asn=65002 --interface=vpc-b-to-transit-tu2 --advertisement-mode=custom --peer-ip-address=169.254.1.14

gcloud compute vpn-tunnels create vpc-b-to-transit-tu1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --vpn-gateway=vpc-b-gw1-usw2 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-transit-gw1-usw2 --router=cr-vpc-b-usw2-1 --ike-version=2 --shared-secret=gcprocks --interface=0

gcloud compute vpn-tunnels create vpc-b-to-transit-tu2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --vpn-gateway=vpc-b-gw1-usw2 --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-transit-gw1-usw2 --router=cr-vpc-b-usw2-1 --ike-version=2 --shared-secret=gcprocks --interface=1

gcloud compute routers add-interface cr-vpc-b-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --interface-name=vpc-b-to-transit-tu1 --vpn-tunnel=vpc-b-to-transit-tu1 --ip-address=169.254.1.10 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-b-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --peer-name=vpc-b-to-transit-bgp1 --peer-asn=65000 --interface=vpc-b-to-transit-tu1 --advertisement-mode=custom --peer-ip-address=169.254.1.9

gcloud compute routers add-interface cr-vpc-b-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --interface-name=vpc-b-to-transit-tu2 --vpn-tunnel=vpc-b-to-transit-tu2 --ip-address=169.254.1.14 --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-b-usw2-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --peer-name=vpc-b-to-transit-bgp2 --peer-asn=65000 --interface=vpc-b-to-transit-tu2 --advertisement-mode=custom --peer-ip-address=169.254.1.13 

# Task 3, Step 3,4 & 5 is completed


gcloud services enable networkconnectivity.googleapis.com


gcloud alpha network-connectivity hubs create transit-hub \
   --description=Transit_hub

gcloud alpha network-connectivity spokes create bo1 \
    --hub=transit-hub \
    --description=branch_office1 \
    --vpn-tunnel=transit-to-vpc-a-tu1,transit-to-vpc-a-tu2 \
    --region=$REGION_1


gcloud alpha network-connectivity spokes create bo2 \
    --hub=transit-hub \
    --description=branch_office2 \
    --vpn-tunnel=transit-to-vpc-b-tu1,transit-to-vpc-b-tu2 \
    --region=$REGION_2

# Task 4 is completed

gcloud compute firewall-rules create fw-a --project=$DEVSHELL_PROJECT_ID --direction=INGRESS --network=vpc-a --action=ALLOW --priority=1000 --rules=tcp:22 --source-ranges=0.0.0.0/0 && gcloud compute firewall-rules create fw-b --project=$DEVSHELL_PROJECT_ID --direction=INGRESS --network=vpc-b --action=ALLOW --priority=1000 --rules=tcp:22 --source-ranges=0.0.0.0/0

gcloud compute instances create vpc-a-vm-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-a-sub1-use4 --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=vpc-a-vm-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20241210,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud compute instances create vpc-b-vm-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_2 --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-b-sub1-usw2 --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=vpc-b-vm-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20241210,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


echo ""

echo "Open this below link to update a Firewall Rule for VPC-A"

echo "${YELLOW}${BOLD}[https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/fw-a?project=$DEVSHELL_PROJECT_ID]${RESET}"

echo ""

echo "Open this below link to update a Firewall Rule for VPC-B"

echo "${YELLOW}${BOLD}[https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/fw-b?project=$DEVSHELL_PROJECT_ID]${RESET}"

echo ""

echo "In the protocal section type"

echo "${YELLOW}${BOLD}icmp"${RESET}

echo ""



