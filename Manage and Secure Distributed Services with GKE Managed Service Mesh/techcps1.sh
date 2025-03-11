gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud config set project $DEVSHELL_PROJECT_ID
gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION

gcloud services enable \
--project=$DEVSHELL_PROJECT_ID \
container.googleapis.com \
mesh.googleapis.com \
gkehub.googleapis.com


gcloud container fleet mesh enable --project=$DEVSHELL_PROJECT_ID

## Task 2

gcloud compute addresses create $REGION-nat-ip \
  --project=$DEVSHELL_PROJECT_ID \
  --region=$REGION

export NAT_REGION_1_IP_ADDR=$(gcloud compute addresses describe $REGION-nat-ip \
  --project=$DEVSHELL_PROJECT_ID \
  --region=$REGION \
  --format='value(address)')


export NAT_REGION_1_IP_NAME=$(gcloud compute addresses describe $REGION-nat-ip \
  --project=$DEVSHELL_PROJECT_ID \
  --region=$REGION \
  --format='value(name)')


gcloud compute routers create rtr-$REGION \
  --network=default \
  --region $REGION
  
gcloud compute routers nats create nat-gw-$REGION \
  --router=rtr-$REGION \
  --region $REGION \
  --nat-external-ip-pool=${NAT_REGION_1_IP_NAME} \
  --nat-all-subnet-ip-ranges \
  --enable-logging


gcloud compute firewall-rules create all-pods-and-master-ipv4-cidrs \
  --project=$DEVSHELL_PROJECT_ID \
  --network default \
  --allow all \
  --direction INGRESS \
  --source-ranges 172.16.0.0/28,172.16.1.0/28,172.16.2.0/28,0.0.0.0/0


export CLOUDSHELL_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
export LAB_VM_IP=$(gcloud compute instances describe lab-setup --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone=$ZONE)



gcloud container clusters create cluster1 \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --machine-type "e2-standard-4" \
  --num-nodes "2" --min-nodes "2" --max-nodes "2" \
  --enable-ip-alias --enable-autoscaling \
  --workload-pool=$DEVSHELL_PROJECT_ID.svc.id.goog \
  --enable-private-nodes \
  --master-ipv4-cidr=172.16.0.0/28 \
  --enable-master-authorized-networks \
  --master-authorized-networks $NAT_REGION_1_IP_ADDR/32,$CLOUDSHELL_IP/32,$LAB_VM_IP/32 --async



gcloud container clusters create cluster2 \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --machine-type "e2-standard-4" \
  --num-nodes "2" --min-nodes "2" --max-nodes "2" \
  --enable-ip-alias --enable-autoscaling \
  --workload-pool=$DEVSHELL_PROJECT_ID.svc.id.goog \
  --enable-private-nodes \
  --master-ipv4-cidr=172.16.1.0/28 \
  --enable-master-authorized-networks \
  --master-authorized-networks $NAT_REGION_1_IP_ADDR/32,$CLOUDSHELL_IP/32,$LAB_VM_IP/32


### Note: It can take up to 10 minutes to provision the GKE clusters.


gcloud container clusters list

touch ~/asm-kubeconfig && export KUBECONFIG=~/asm-kubeconfig
gcloud container clusters get-credentials cluster1 --zone $ZONE
gcloud container clusters get-credentials cluster2 --zone $ZONE

kubectl config get-contexts


kubectl config rename-context \
gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 cluster1

kubectl config rename-context \
gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 cluster2


kubectl config get-contexts --output="name"


gcloud container fleet memberships register cluster1 --gke-cluster=${ZONE}/cluster1 --enable-workload-identity
gcloud container fleet memberships register cluster2 --gke-cluster=${ZONE}/cluster2 --enable-workload-identity


export CLOUDSHELL_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
export LAB_VM_IP=$(gcloud compute instances describe lab-setup --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone=$ZONE)
export NAT_REGION_1_IP_ADDR=$(gcloud compute addresses describe $REGION-nat-ip \
  --project=$DEVSHELL_PROJECT_ID \
  --region=$REGION \
  --format='value(address)')


gcloud container clusters update cluster1 \
  --zone=$ZONE \
  --enable-master-authorized-networks \
  --master-authorized-networks $NAT_REGION_1_IP_ADDR/32,$CLOUDSHELL_IP/32,$LAB_VM_IP/32

gcloud container clusters update cluster2 \
  --zone=$ZONE \
  --enable-master-authorized-networks \
  --master-authorized-networks $NAT_REGION_1_IP_ADDR/32,$CLOUDSHELL_IP/32,$LAB_VM_IP/32

## Task 3

gcloud container fleet mesh update --management automatic --memberships cluster1,cluster2
