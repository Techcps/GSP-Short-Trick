

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

export REGION_1=${ZONE_1%-*}

export REGION_2=${ZONE_2%-*}

export VM_NAME_1=us-test-01

export VM_NAME_2=us-test-02

gcloud compute networks create $VPC_NAME --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create $SUBNET_1 --project=$DEVSHELL_PROJECT_ID --region=$REGION_1 --network=$VPC_NAME --range=10.10.10.0/24 --stack-type=IPV4_ONLY

gcloud compute networks subnets create $SUBNET_2 --project=$DEVSHELL_PROJECT_ID --region=$REGION_2 --network=$VPC_NAME --range=10.10.20.0/24 --stack-type=IPV4_ONLY


gcloud compute firewall-rules create $RULE_CP1 --project=$DEVSHELL_PROJECT_ID --network=$VPC_NAME --direction=INGRESS --priority=1000 --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0 --target-tags=all


gcloud compute firewall-rules create $RULE_CP2 --project=$DEVSHELL_PROJECT_ID --network=$VPC_NAME --direction=INGRESS --priority=65535 --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/24 --target-tags=all


gcloud compute firewall-rules create $RULE_CP3 --project=$DEVSHELL_PROJECT_ID --network=$VPC_NAME --direction=INGRESS --priority=65535 --action=ALLOW --rules=icmp --source-ranges=0.0.0.0/24 --target-tags=all

export VM_NAME_1=us-test-01

gcloud compute instances create $VM_NAME_1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --subnet=$SUBNET_1 --tags=allow-icmp

export VM_NAME_2=us-test-02

gcloud compute instances create $VM_NAME_2 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_2 --subnet=$SUBNET_2 --tags=allow-icmp

sleep 10

export EXTERNAL_IP2=$(gcloud compute instances describe $VM_NAME_2 --zone=$ZONE_2 --format='get(networkInterfaces[0].accessConfigs[0].natIP)')


echo $EXTERNAL_IP2

gcloud compute ssh $VM_NAME_1 --zone=$ZONE_1 --project=$DEVSHELL_PROJECT_ID --quiet --command="ping -c 3 $EXTERNAL_IP2 && ping -c 3 $VM_NAME_2.$ZONE_2"


