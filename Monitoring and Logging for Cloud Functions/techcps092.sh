
gcloud auth list
gcloud config list project

cat > index.js <<EOF_CP
exports.helloWorld = (req, res) => {
    res.status(200).send('Hello World!');
};
EOF_CP


#!/bin/bash

deploy_function() {
  gcloud functions deploy helloWorld --runtime nodejs20 --trigger-http --allow-unauthenticated --region $REGION --max-instances 5
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully (https://www.youtube.com/@techcps)."
    deploy_success=true
  else
    echo "Retring please subscribe to techcps (https://www.youtube.com/@techcps)."
    sleep 10
  fi
done


gcloud logging metrics create CloudFunctionLatency-Logs --project=$DEVSHELL_PROJECT_ID --description="like share & subscribe to techcps" --log-filter='resource.type="cloud_function"
resource.labels.function_name="helloWorld"'

