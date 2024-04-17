

export REGION1="${ZONE1%-*}"

export REGION2="${ZONE2%-*}"

export REGION3="${ZONE3%-*}"

gcloud compute networks create taw-custom-network --subnet-mode custom

gcloud compute networks subnets create subnet-$REGION1 \
   --network taw-custom-network \
   --region $REGION1 \
   --range 10.0.0.0/16

gcloud compute networks subnets create subnet-$REGION2 \
   --network taw-custom-network \
   --region $REGION2 \
   --range 10.1.0.0/16   

gcloud compute networks subnets create subnet-$REGION3 \
   --network taw-custom-network \
   --region $REGION3 \
   --range 10.2.0.0/16


gcloud compute networks subnets list \
   --network taw-custom-network

gcloud compute firewall-rules create nw101-allow-http \
--allow tcp:80 --network taw-custom-network --source-ranges 0.0.0.0/0 \
--target-tags http

gcloud compute firewall-rules create "nw101-allow-icmp" --allow icmp --network "taw-custom-network" --target-tags rules

gcloud compute firewall-rules create "nw101-allow-internal" --allow tcp:0-65535,udp:0-65535,icmp --network "taw-custom-network" --source-ranges "10.0.0.0/16","10.2.0.0/16","10.1.0.0/16"

gcloud compute firewall-rules create "nw101-allow-ssh" --allow tcp:22 --network "taw-custom-network" --target-tags "ssh"

gcloud compute firewall-rules create "nw101-allow-rdp" --allow tcp:3389 --network "taw-custom-network"


gcloud compute instances create us-test-01 \
--subnet subnet-$REGION1 \
--zone ZONE \
--machine-type e2-standard-2 \
--tags ssh,http,rules


gcloud compute instances create us-test-02 \
--subnet subnet-$REGION2 \
--zone ZONE \
--machine-type e2-standard-2 \
--tags ssh,http,rules

gcloud compute instances create us-test-03 \
--subnet subnet-$REGION3 \
--zone ZONE \
--machine-type e2-standard-2 \
--tags ssh,http,rules


