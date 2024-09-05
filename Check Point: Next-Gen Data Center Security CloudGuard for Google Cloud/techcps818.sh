
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION


gcloud compute networks create vpc-cluster --project=$DEVSHELL_PROJECT_ID --bgp-routing-mode=regional --subnet-mode=custom

gcloud compute networks subnets create cluster --project=$DEVSHELL_PROJECT_ID --region=$REGION --network=vpc-cluster --enable-private-ip-google-access --range=192.168.110.0/24

gcloud compute networks create vpc-management --project=$DEVSHELL_PROJECT_ID --bgp-routing-mode=regional --subnet-mode=custom

gcloud compute networks subnets create management --project=$DEVSHELL_PROJECT_ID --region=$REGION --network=vpc-management --enable-private-ip-google-access --range=192.168.120.0/24

gcloud compute networks create vpc-prod --project=$DEVSHELL_PROJECT_ID --bgp-routing-mode=regional --subnet-mode=custom

gcloud compute networks subnets create prod --project=$DEVSHELL_PROJECT_ID --region=$REGION --network=vpc-prod --range=10.0.0.0/24

gcloud compute networks create vpc-qa --project=$DEVSHELL_PROJECT_ID --bgp-routing-mode=regional --subnet-mode=custom

gcloud compute networks subnets create qa --project=$DEVSHELL_PROJECT_ID  --region=$REGION --network=vpc-qa --range=10.0.1.0/24

gcloud compute firewall-rules create ingress-qa --project=$DEVSHELL_PROJECT_ID --action allow --direction=INGRESS --network=vpc-qa --source-ranges=0.0.0.0/0 --rules all

gcloud compute firewall-rules create ingress-prod --project=$DEVSHELL_PROJECT_ID --action allow --direction=INGRESS --source-ranges=0.0.0.0/0 --network=vpc-prod --rules all

gcloud compute firewall-rules create rdp-management --project=$DEVSHELL_PROJECT_ID --action allow --direction=INGRESS --source-ranges=0.0.0.0/0 --network=vpc-management --rules tcp:3389

gcloud compute instances create rdp-client --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --machine-type=n1-standard-4 --image-project=qwiklabs-resources --image=sap-rdp-image --network=vpc-management --subnet=management --tags=rdp,http-server,https-server --boot-disk-type=pd-ssd

gcloud compute instances create linux-qa --zone $ZONE --project=$DEVSHELL_PROJECT_ID --image-project=debian-cloud --image-family=debian-11 --custom-cpu 1 --custom-memory 4 --network-interface subnet=qa,private-network-ip=10.0.1.4,no-address --metadata startup-script="\#! /bin/bash
useradd -m -p sa1trmaMoZ25A cp
EOF"

gcloud compute instances create linux-prod --zone $ZONE --project=$DEVSHELL_PROJECT_ID --image-project=debian-cloud --image-family=debian-11 --custom-cpu 1 --custom-memory 4 --network-interface subnet=prod,private-network-ip=10.0.0.4,no-address --metadata startup-script="\#! /bin/bash
useradd -m -p sa1trmaMoZ25A cp
EOF"


