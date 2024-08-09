
gcloud auth list

gcloud config set compute/zone $ZONE 

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud compute instances create sqlserver-lab --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --image-family=sql-2016-web-windows-2016 --image-project=windows-sql-cloud --machine-type=e2-medium --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=sqlserver-lab,image=projects/windows-sql-cloud/global/images/sql-2016-web-windows-2016-dc-v20240711,mode=rw,size=50,type=pd-balanced


gcloud compute reset-windows-password sqlserver-lab --zone=$ZONE --quiet

