
# Securing Virtual Machines using BeyondCorp Enterprise (BCE)[GSP1036]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)


```
export ZONE=
```
```
gcloud services enable iap.googleapis.com
gcloud compute instances create linux-iap --machine-type e2-medium --subnet=default --no-address --zone=$ZONE
gcloud compute instances create windows-iap --machine-type e2-medium --subnet=default --no-address --zone=$ZONE --create-disk auto-delete=yes,boot=yes,device-name=windows-iap,image=projects/windows-cloud/global/images/windows-server-2016-dc-v20230315,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/us-east1-c/diskTypes/pd-balanced
gcloud compute instances create windows-connectivity --machine-type e2-medium --zone=$ZONE --create-disk auto-delete=yes,boot=yes,device-name=windows-connectivity,image=projects/qwiklabs-resources/global/images/iap-desktop-v001,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/us-east1-c/diskTypes/pd-balanced --scopes https://www.googleapis.com/auth/cloud-platform
```
## Perform task 3 & 4 using lab instruction.

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
