

gcloud auth list

gcloud config set project $DEVSHELL_PROJECT_ID

gcloud services enable artifactregistry.googleapis.com cloudfunctions.googleapis.com cloudbuild.googleapis.com eventarc.googleapis.com run.googleapis.com logging.googleapis.com pubsub.googleapis.com


sleep 45

gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID


PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$DEVSHELL_PROJECT_ID" --format='value(project_number)')
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/artifactregistry.reader

export BUCKET="gs://$DEVSHELL_PROJECT_ID"


mkdir techcps && cd techcps

cat > index.js <<EOF_CP
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
exports.GCFunction = (req, res) => {
    let message = req.query.message || req.body.message || 'subscribe to techcps';
    res.status(200).send(message);
  };

EOF_CP


cat > package.json <<EOF_CP
{
    "name": "sample-http",
    "version": "3.0.0"
  }
  
EOF_CP



#!/bin/bash

deploy_function() {
gcloud functions deploy GCFunction \
  --region=$REGION \
  --gen2 \
  --trigger-http \
  --runtime=nodejs20 \
  --allow-unauthenticated \
  --max-instances=5 \
  --source . --quiet
}

deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully!"
    deploy_success=true
  else
    echo "Retrying, please subscribe to techcps[https://www.youtube.com/@techcps]."
    sleep 10
  fi
done

DATA=$(printf 'subscribe to techcps' | base64) && gcloud functions call GCFunction --region=$REGION --data '{"data":"'$DATA'"}'

