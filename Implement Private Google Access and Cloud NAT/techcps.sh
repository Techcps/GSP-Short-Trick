

export REGION=${ZONE%-*}

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud compute networks create privatenet --project=$PROJECT_ID --subnet-mode custom

gcloud compute networks subnets create privatenet-us --project=$PROJECT_ID --network=privatenet --region=$REGION --range=10.130.0.0/20

gcloud compute firewall-rules create privatenet-allow-ssh --project=$PROJECT_ID --network=privatenet --action=ALLOW --rules=tcp:22 --source-ranges=35.235.240.0/20

gcloud compute instances create vm-internal --zone=$ZONE --project=$PROJECT_ID --machine-type=e2-medium --image-project=debian-cloud --image-family=debian-11 --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=vm-internal --create-disk=mode=rw,size=10GB,type=pd-standard --network=privatenet  --subnet=privatenet-us --no-address

gsutil mb gs://$PROJECT_ID-techcps

gcloud storage cp gs://cloud-training/gcpnet/private/access.svg gs://$PROJECT_ID-techcps

gcloud storage cp gs://$PROJECT_ID-techcps/*.svg .

gcloud compute networks subnets update privatenet-us --region=$REGION --enable-private-ip-google-access

gcloud compute routers create nat-router --network=privatenet --region=$REGION

gcloud compute routers get-status nat-router --region=$REGION 

