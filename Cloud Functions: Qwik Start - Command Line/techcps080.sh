

gcloud auth list
gcloud config list project

gcloud services disable cloudfunctions.googleapis.com
gcloud services enable cloudfunctions.googleapis.com


gcloud config set compute/region $REGION
mkdir gcf_hello_world

cd gcf_hello_world
cat > index.js << EOF_CP
/**
* Background Cloud Function to be triggered by Pub/Sub.
* This function is exported by index.js, and executed when
* the trigger topic receives a message.
*
* @param {object} data The event payload.
* @param {object} context The event metadata.
*/
exports.helloWorld = (data, context) => {
const pubSubMessage = data;
const name = pubSubMessage.data
    ? Buffer.from(pubSubMessage.data, 'base64').toString() : "Hello World";
    
console.log("My Cloud Function: "+name);
};
EOF_CP

gsutil mb -p $DEVSHELL_PROJECT_ID gs://$DEVSHELL_PROJECT_ID

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member="serviceAccount:$DEVSHELL_PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"

#!/bin/bash

deploy_function() {
  gcloud functions deploy helloWorld --stage-bucket $DEVSHELL_PROJECT_ID --trigger-topic hello_world --runtime nodejs20
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully."
    deploy_success=true
  else
    echo "Retrying, please subscribe to techcps (https://www.youtube.com/@techcps)..."
    sleep 10
  fi
done


gcloud functions describe helloWorld

