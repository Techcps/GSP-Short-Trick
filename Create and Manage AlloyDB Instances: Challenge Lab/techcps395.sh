

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION


gcloud beta alloydb clusters create lab-cluster --project=$DEVSHELL_PROJECT_ID --region=$REGION --password=Change3Me --network=peering-network
     

gcloud beta alloydb instances create lab-instance --project=$DEVSHELL_PROJECT_ID --region=$REGION --cluster=lab-cluster --instance-type=PRIMARY --cpu-count=2
    

gcloud alloydb instances create lab-instance-rp1 --project=$DEVSHELL_PROJECT_ID --region=$REGION --cluster=lab-cluster --instance-type=READ_POOL --cpu-count=2 --read-pool-node-count=2

gcloud beta alloydb backups create lab-backup --project=$DEVSHELL_PROJECT_ID --region=$REGION --cluster=lab-cluster


