
gcloud compute instances create vm-premium --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-tier=PREMIUM --image-family=debian-11 --image-project=debian-cloud && gcloud compute instances create vm-standard --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-tier=STANDARD --image-family=debian-11 --image-project=debian-cloud

