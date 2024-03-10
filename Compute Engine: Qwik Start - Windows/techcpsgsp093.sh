
gcloud compute instances create techcps --project=$DEVSHELL_PROJECT_ID --zone $ZONE --machine-type=e2-medium --create-disk=auto-delete=yes,boot=yes,device-name=techcps,image=projects/windows-cloud/global/images/windows-server-2022-dc-v20230913,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced 
