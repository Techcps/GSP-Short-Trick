

gcloud auth list

gcloud services enable servicedirectory.googleapis.com

sleep 5

gcloud service-directory namespaces create example-namespace --project=$DEVSHELL_PROJECT_ID --location=$REGION

gcloud service-directory services create example-service --project=$DEVSHELL_PROJECT_ID --location=$REGION --namespace=example-namespace

gcloud service-directory endpoints create example-endpoint --location=$REGION --project=$DEVSHELL_PROJECT_ID --namespace=example-namespace --service=example-service --address=0.0.0.0 --port=80
    
gcloud dns --project=$DEVSHELL_PROJECT_ID managed-zones create example-zone-name --description="subscribe to techcps" --dns-name="myzone.example.com." --visibility="private" --networks="https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/networks/default" --service-directory-namespace="https://servicedirectory.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/$REGION/namespaces/example-namespace"

