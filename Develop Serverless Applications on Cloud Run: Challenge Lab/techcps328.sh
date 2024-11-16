
#!/bin/bash

YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"

# Export the variables name correctly
read -p -e "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION
read -p -e "${YELLOW}${BOLD}Enter the CP1_PBS: ${RESET}" CP1_PBS
read -p -e "${YELLOW}${BOLD}Enter the CP2_FSS: ${RESET}" CP2_FSS
read -p -e "${YELLOW}${BOLD}Enter the CP3_PBS: ${RESET}" CP3_PBS
read -p -e "${YELLOW}${BOLD}Enter the CP4_BSA: ${RESET}" CP4_BSA
read -p -e "${YELLOW}${BOLD}Enter the CP5_BPS: ${RESET}" CP5_BPS
read -p -e "${YELLOW}${BOLD}Enter the CP6_FSA: ${RESET}" CP6_FSA
read -p -e "${YELLOW}${BOLD}Enter the CP7_FPS: ${RESET}" CP7_FPS

gcloud auth list

gcloud config set project \
$(gcloud projects list --format='value(PROJECT_ID)' \
--filter='qwiklabs-gcp')

gcloud config set run/region $REGION

gcloud config set run/platform managed

git clone https://github.com/rosera/pet-theory.git && cd pet-theory/lab07


# Task 1. Enable a Public Service

cd ~/pet-theory/lab07/unit-api-billing

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.1
gcloud run deploy $CP1_PBS --image gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.1 --quiet

# Task 2. Deploy a Frontend Service

cd ~/pet-theory/lab07/staging-frontend-billing

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1
gcloud run deploy $CP2_FSS --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1 --quiet

# Task 3. Deploy a Private Service

cd ~/pet-theory/lab07/staging-api-billing

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.2
gcloud run deploy $CP3_PBS --image gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.2 --quiet

# Task 4. Create a Billing Service Account

gcloud iam service-accounts create $CP4_BSA --display-name "Billing Service Account Cloud Run"


# Task 5. Deploy the Billing Service

cd ~/pet-theory/lab07/prod-api-billing

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-prod-api:0.1
gcloud run deploy $CP5_BPS --image gcr.io/$DEVSHELL_PROJECT_ID/billing-prod-api:0.1 --quiet

# Task 6. Frontend Service Account

gcloud iam service-accounts create $CP6_FSA --display-name "Billing Service Account Cloud Run Invoker"

# Task 7. Redeploy the Frontend Service

cd ~/pet-theory/lab07/prod-frontend-billing

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-prod:0.1
gcloud run deploy $CP7_FPS --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-prod:0.1 --quiet

