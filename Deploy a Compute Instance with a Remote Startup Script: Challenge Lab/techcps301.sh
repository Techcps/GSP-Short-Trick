
gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil cp gs://sureskills-ql/challenge-labs/ch01-startup-script/install-web.sh gs://$DEVSHELL_PROJECT_ID

gcloud compute instances create techcps --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=n1-standard-1 --tags=http-server --metadata startup-script-url=gs://$DEVSHELL_PROJECT_ID/install-web.sh


gcloud compute firewall-rules create allow-http \
    --allow=tcp:80 \
    --description="subscribe to techcps" \
    --direction=INGRESS \
    --target-tags=http-server

