

gcloud auth list

echo "Click this link to open new tab https://console.cloud.google.com/security/iap/getStarted?cloudshell=true&project=$DEVSHELL_PROJECT_ID"

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/region $REGION

git clone https://github.com/googlecodelabs/user-authentication-with-iap.git
cd user-authentication-with-iap

cd 1-HelloWorld

gcloud app create --project=$(gcloud config get-value project) --region=$REGION

sed -i "15c\runtime: python38" app.yaml

sleep 25

#!/bin/bash

deploy_app() {
  gcloud app deploy --quiet
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_app; then
    echo "App deployed successfully."
    deploy_success=true
  else
    echo "Deployment failed. Retrying in 10 seconds..."
    echo "Please subscribe to techcps (https://www.youtube.com/@techcps)."
    sleep 10
  fi
done


cd ~/user-authentication-with-iap/2-

sed -i "15c\runtime: python38" app.yaml

sleep 25

#!/bin/bash

deploy_app() {
  gcloud app deploy --quiet
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_app; then
    echo "App deployed successfully."
    deploy_success=true
  else
    echo "Deployment failed. Retrying in 10 seconds..."
    echo "Please subscribe to techcps (https://www.youtube.com/@techcps)."
    sleep 10
  fi
done

echo "Congratulations, you're all done with the lab"
echo "Please like share and subscribe to techcps(https://www.youtube.com/@techcps)..."
