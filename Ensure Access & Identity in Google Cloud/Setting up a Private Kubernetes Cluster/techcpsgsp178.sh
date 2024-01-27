
gcloud auth list
gcloud config list project

# Set the region and zone
gcloud config set compute/zone $ZONE

export REGION=${ZONE::-2}
# Task 1 is completed

# Creating a private cluster
gcloud beta container clusters create private-cluster --enable-private-nodes --master-ipv4-cidr 172.16.0.16/28 --enable-ip-alias --create-subnetwork ""
# Task 2 is completed 

# Enabling master authorized networks
gcloud compute instances create source-instance --zone=$ZONE --scopes 'https://www.googleapis.com/auth/cloud-platform'
NAT_IAP=$(gcloud compute instances describe source-instance --zone=$ZONE | grep natIP | awk '{print $2}')
gcloud container clusters update private-cluster --enable-master-authorized-networks --master-authorized-networks $NAT_IAP/32
# Task 4 is completed

# Clean Up
gcloud container clusters delete private-cluster --zone=$ZONE --quiet
# Task 5 is completed 

# Creating a private cluster that uses a custom subnetwork
gcloud compute networks subnets create my-subnet --network default --range 10.0.4.0/22 --enable-private-ip-google-access --region=$REGION --secondary-range my-svc-range=10.0.32.0/20,my-pod-range=10.4.0.0/14
    
gcloud beta container clusters create private-cluster2 --enable-private-nodes --enable-ip-alias --master-ipv4-cidr 172.16.0.32/28 --subnetwork my-subnet --services-secondary-range-name my-svc-range --cluster-secondary-range-name my-pod-range --zone=$ZONE
NAT_IAP_CP=$(gcloud compute instances describe source-instance --zone=$ZONE | grep natIP | awk '{print $2}')
gcloud container clusters update private-cluster2 --enable-master-authorized-networks --zone=$ZONE --master-authorized-networks $NAT_IAP_CP/32

## Congratulations, you're all done with the lab 😄 
# Thanks for watching :)
