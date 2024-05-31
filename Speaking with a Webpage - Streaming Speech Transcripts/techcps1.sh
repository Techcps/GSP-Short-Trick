

gcloud compute ssh "speaking-with-a-webpage" --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet --command "pkill -f 'java.*jetty'"

sleep 10

gcloud compute ssh "speaking-with-a-webpage" --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet --command "cd ~/speaking-with-a-webpage/02-webaudio && mvn clean jetty:run"


