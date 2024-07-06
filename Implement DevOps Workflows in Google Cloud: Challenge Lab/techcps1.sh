

gcloud auth list

gcloud config set project $DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE
export REGION="${ZONE%-*}"
gcloud config set compute/region $REGION

gcloud services enable container.googleapis.com \
    cloudbuild.googleapis.com \
    sourcerepo.googleapis.com

sleep 30

export PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
--format="value(projectNumber)")@cloudbuild.gserviceaccount.com --role="roles/container.developer"

git config --global user.email $USER_EMAIL
git config --global user.name student

gcloud artifacts repositories create $REPO --repository-format=docker --location=$REGION --description="Subscribe to techcps"

gcloud beta container --project=$PROJECT_ID clusters create "$CLUSTER_NAME" --zone=$ZONE --no-enable-basic-auth --cluster-version latest --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true  --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$PROJECT_ID/global/networks/default" --subnetwork "projects/$PROJECT_ID/regions/$REGION/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-autoscaling --min-nodes "2" --max-nodes "6" --location-policy "BALANCED" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "$ZONE"



#!/bin/bash

cp_exists() {
    local namespace="$1"
    kubectl get namespace "$namespace" &> /dev/null
}

if ! cp_exists "prod"; then
    echo "Creating 'prod' namespace..."
    kubectl create namespace prod
else
    echo "'prod' $namespace already exists."
fi


sleep 15

if ! cp_exists "dev"; then
    echo "Creating 'dev' namespace..."
    kubectl create namespace dev
else
    echo "'dev' $namespace already exists."
fi




sleep 20




gcloud source repos create sample-app

git clone https://source.developers.google.com/p/$PROJECT_ID/r/sample-app

sleep 5

cd ~
gsutil cp -r gs://spls/gsp330/sample-app/* sample-app


for file in sample-app/cloudbuild-dev.yaml sample-app/cloudbuild.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
done



git init
cd sample-app/
git add .
git commit -m "Subscribe to techcps" 
git push -u origin master



git branch dev
git checkout dev
git push -u origin dev


echo "---------------subscribe to techcps----------------"

echo "---------------subscribe to techcps----------------"

echo "----------------subscribe to techcps https://www.youtube.com/@techcps, ----------------"

echo "----------------subscribe to techcps https://www.youtube.com/@techcps, ----------------"

echo "----------------Please like the video----------------"

echo "----------------Click the link below----------------"

echo "subscribe to techcps https://console.cloud.google.com/cloud-build/triggers?cloudshell=true&project=$DEVSHELL_PROJECT_ID"

echo "---------------Click the above link----------------"

echo "---------------subscribe to techcps----------------"

echo "---------------Please like share and subscribe to techcps----------------"




