

export REGION="${ZONE%-*}"
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set compute/region $REGION

gcloud services enable \
container.googleapis.com \
clouddeploy.googleapis.com \
artifactregistry.googleapis.com \
cloudbuild.googleapis.com \
clouddeploy.googleapis.com

sleep 45

gcloud container clusters create test --node-locations="$ZONE" --num-nodes=1  --async
gcloud container clusters create staging --node-locations="$ZONE" --num-nodes=1  --async
gcloud container clusters create prod --node-locations="$ZONE" --num-nodes=1  --async


gcloud container clusters list --format="csv(name,status)"


gcloud artifacts repositories create web-app \
--description="Image registry for tutorial web app" \
--repository-format=docker \
--location=$REGION



cd ~/
git clone https://github.com/GoogleCloudPlatform/cloud-deploy-tutorials.git
cd cloud-deploy-tutorials
git checkout c3cae80 --quiet
cd tutorials/base



envsubst < clouddeploy-config/skaffold.yaml.template > web/skaffold.yaml
cat web/skaffold.yaml



cd web
skaffold build --interactive=false \
--default-repo $REGION-docker.pkg.dev/$PROJECT_ID/web-app \
--file-output artifacts.json
cd ..



gcloud artifacts docker images list \
$REGION-docker.pkg.dev/$PROJECT_ID/web-app \
--include-tags \
--format yaml



cat web/artifacts.json | jq



gcloud config set deploy/region $REGION
cp clouddeploy-config/delivery-pipeline.yaml.template clouddeploy-config/delivery-pipeline.yaml
gcloud beta deploy apply --file=clouddeploy-config/delivery-pipeline.yaml



gcloud beta deploy delivery-pipelines describe web-app


#!/bin/bash

while true; do
    # Get the status of the clusters
    cluster_status=$(gcloud container clusters list --format="csv(name,status)" | tail -n +2)

    # Check if all clusters are in the RUNNING state
    if echo "$cluster_status" | grep -q "RUNNING"; then
        echo "All clusters are now running."
        break
    else
        echo "clusters not running. Please subscribe to techcps (https://www.youtube.com/@techcps).."
        sleep 10
    fi
done



CONTEXTS=("test" "staging" "prod")
for CONTEXT in ${CONTEXTS[@]}
do
    gcloud container clusters get-credentials ${CONTEXT} --region ${REGION}
    kubectl config rename-context gke_${PROJECT_ID}_${REGION}_${CONTEXT} ${CONTEXT}
done

for CONTEXT in ${CONTEXTS[@]}
do
    kubectl --context ${CONTEXT} apply -f kubernetes-config/web-app-namespace.yaml
done


for CONTEXT in ${CONTEXTS[@]}
do
    envsubst < clouddeploy-config/target-$CONTEXT.yaml.template > clouddeploy-config/target-$CONTEXT.yaml
    gcloud beta deploy apply --file clouddeploy-config/target-$CONTEXT.yaml
done



cat clouddeploy-config/target-test.yaml

cat clouddeploy-config/target-prod.yaml

gcloud beta deploy targets list



gcloud beta deploy releases create web-app-001 \
--delivery-pipeline web-app \
--build-artifacts web/artifacts.json \
--source web/


while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --format="value(state)" | head -n 1)
  if [ "$status" == "SUCCEEDED" ]; then
    break
  fi
  echo "It's deploying, so Please subscribe to techcps (https://www.youtube.com/@techcps)."
  sleep 10
done



kubectx test
kubectl get all -n web-app


gcloud beta deploy releases promote \
--delivery-pipeline web-app \
--release web-app-001 --quiet 


while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --format="value(state)" | head -n 1)
  if [ "$status" == "SUCCEEDED" ]; then
    break
  fi
  echo "It's deploying, so Please subscribe to techcps (https://www.youtube.com/@techcps)."
  sleep 10
done


gcloud beta deploy releases promote \
--delivery-pipeline web-app \
--release web-app-001 --quiet


while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --format="value(state)" | head -n 1)
  if [ "$status" == "PENDING_APPROVAL" ]; then
    break
  fi
  echo "It's deploying, so Please subscribe to techcps (https://www.youtube.com/@techcps)."
  sleep 10
done


gcloud beta deploy rollouts approve web-app-001-to-prod-0001 \
--delivery-pipeline web-app \
--release web-app-001 --quiet


while true; do
  status=$(gcloud beta deploy rollouts list --delivery-pipeline web-app --release web-app-001 --format="value(state)" | head -n 1)
  if [ "$status" == "SUCCEEDED" ]; then
    break
  fi
  echo "It's deploying, so Please subscribe to techcps (https://www.youtube.com/@techcps)."
  sleep 10
done


kubectx prod
kubectl get all -n web-app
