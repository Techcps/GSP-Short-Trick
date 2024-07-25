


gcloud auth list

gcloud config set project $DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION="${ZONE%-*}"
gcloud config set compute/region $REGION


gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --machine-type=e2-micro \
    --image-family=debian-11 \
    --image-project=debian-cloud

          
gcloud compute networks create nucleus-vpc --subnet-mode=auto

gcloud container clusters create nucleus-backend --zone=$ZONE --num-nodes 1 --network nucleus-vpc

gcloud container clusters get-credentials nucleus-backend --zone=$ZONE

kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:2.0

kubectl expose deployment hello-server --type=LoadBalancer --port $PORT

cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

gcloud compute instance-templates create web-server-template --region=$ZONE --machine-type g1-small --metadata-from-file startup-script=startup.sh --network nucleus-vpc

gcloud compute target-pools create nginx-pool --region=$REGION

gcloud compute instance-groups managed create web-server-group --region=$REGION --base-instance-name web-server --size 2 --template web-server-template

gcloud compute firewall-rules create $FIREWALL_RULE --network nucleus-vpc --allow tcp:80

gcloud compute http-health-checks create http-basic-check

gcloud compute instance-groups managed \
set-named-ports web-server-group --region=$REGION \
--named-ports http:80

gcloud compute backend-services create web-server-backend --protocol HTTP --http-health-checks http-basic-check --global

gcloud compute backend-services add-backend web-server-backend --instance-group web-server-group --instance-group-region $REGION --global

gcloud compute url-maps create web-server-map --default-service web-server-backend

gcloud compute target-http-proxies create http-lb-proxy --url-map web-server-map

gcloud compute forwarding-rules create http-content-rule --global --target-http-proxy http-lb-proxy --ports 80

gcloud compute forwarding-rules create $FIREWALL_RULE --global --target-http-proxy http-lb-proxy --ports 80


gcloud compute forwarding-rules list


