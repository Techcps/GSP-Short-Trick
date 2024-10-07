
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com
  
sleep 30

mkdir ~/hello-http && cd $_
touch index.js && touch package.json

cat > index.js <<EOF_CP
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
exports.helloWorld = (req, res) => {
  let message = req.query.message || req.body.message || 'Hello World!';
  res.status(200).send(message);
};
EOF_CP

cat > package.json <<EOF_CP
{
  "name": "sample-http",
  "version": "0.0.1"
}
EOF_CP

#!/bin/bash

deploy_function() {
  gcloud functions deploy helloWorld --runtime nodejs20 --trigger-http --allow-unauthenticated --region $REGION --max-instances 5
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully[https://www.youtube.com/@techcps]."
    deploy_success=true
  else
    echo "Retrying, please subscribe to techcps[https://www.youtube.com/@techcps]."
    sleep 20
  fi
done


curl -LO 'https://github.com/tsenart/vegeta/releases/download/v6.3.0/vegeta-v6.3.0-linux-386.tar.gz'

tar xvzf vegeta-v6.3.0-linux-386.tar.gz


gcloud logging metrics create CloudFunctionLatency-Logs --project=$DEVSHELL_PROJECT_ID --description="like share & subscribe to techcps" --log-filter='resource.type="cloud_function"
resource.labels.function_name="helloWorld"'

