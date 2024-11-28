

# Set text styles
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)

BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE

export ZONE

gcloud services enable iap.googleapis.com --project=$DEVSHELL_PROJECT_ID

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")


gcloud compute instances create linux-iap --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type e2-medium --subnet=default --no-address

gcloud compute instances create windows-iap --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type e2-medium --subnet=default --no-address --create-disk auto-delete=yes,boot=yes,device-name=windows-iap,image=projects/windows-cloud/global/images/windows-server-2016-dc-v20230315,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/us-east1-c/diskTypes/pd-balanced

gcloud compute instances create windows-connectivity --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type e2-medium --create-disk auto-delete=yes,boot=yes,device-name=windows-connectivity,image=projects/qwiklabs-resources/global/images/iap-desktop-v001,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/us-east1-c/diskTypes/pd-balanced --scopes https://www.googleapis.com/auth/cloud-platform

gcloud compute firewall-rules create allow-ingress-from-iap --project=$DEVSHELL_PROJECT_ID --direction=INGRESS --action=ALLOW --rules=tcp:22,tcp:3389 --source-ranges=35.235.240.0/20 --target-tags=allow-ingress-from-iap

echo "----------------"

echo ""

echo "Open Firewall Rule ${BLUE}https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/allow-ingress-from-iap?project=$DEVSHELL_PROJECT_ID${RESET}"

echo ""

echo "Open IAP Settings ${BLUE}https://console.cloud.google.com/security/iap?tab=ssh-tcp-resources&project=$DEVSHELL_PROJECT_ID${RESET}"

echo ""

echo "${YELLOW}$PROJECT_NUMBER-compute@developer.gserviceaccount.com${RESET}"

echo ""


