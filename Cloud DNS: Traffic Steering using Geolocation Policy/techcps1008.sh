
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export REGION1=${ZONE1%-*}

export REGION2=${ZONE2%-*}

export REGION3=${ZONE3%-*}


gcloud services enable compute.googleapis.com

gcloud services enable dns.googleapis.com

gcloud services list | grep -E 'compute|dns'

gcloud compute firewall-rules create fw-default-iapproxy \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:22,icmp \
--source-ranges=35.235.240.0/20


gcloud compute firewall-rules create allow-http-traffic --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server


gcloud compute instances create us-client-vm --machine-type e2-medium --zone=$ZONE1

gcloud compute instances create europe-client-vm --machine-type e2-medium --zone=$ZONE2

gcloud compute instances create asia-client-vm --machine-type e2-medium --zone=$ZONE3


gcloud compute instances create us-web-vm \
--zone=$ZONE1 \
--machine-type=e2-medium \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "Page served from: $REGION1" | \
 tee /var/www/html/index.html
 systemctl restart apache2'


gcloud compute instances create europe-web-vm \
--zone=$ZONE2 \
--machine-type=e2-medium \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "Page served from: $REGION2" | \
 tee /var/www/html/index.html
 systemctl restart apache2' 


export US_WEB_IP=$(gcloud compute instances describe us-web-vm --zone=$ZONE1 --format="value(networkInterfaces.networkIP)")

export EUROPE_WEB_IP=$(gcloud compute instances describe europe-web-vm --zone=$ZONE2 --format="value(networkInterfaces.networkIP)")

gcloud dns managed-zones create example --description=test --dns-name=example.com --networks=default --visibility=private


gcloud beta dns record-sets create geo.example.com \
--ttl=5 --type=A --zone=example \
--routing_policy_type=GEO \
--routing_policy_data="$REGION1=$US_WEB_IP;$REGION2=$EUROPE_WEB_IP"


gcloud beta dns record-sets list --zone=example


