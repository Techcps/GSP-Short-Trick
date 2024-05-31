

gcloud auth list

gcloud compute instances create speaking-with-a-webpage  --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --image=debian-11-bullseye-v20230509 --image-project=debian-cloud --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server,https-server


sleep 15

gcloud compute ssh "speaking-with-a-webpage" --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet --command "sudo apt update && sudo apt install git -y && sudo apt-get install -y maven openjdk-11-jdk && git clone https://github.com/googlecodelabs/speaking-with-a-webpage.git && gcloud compute firewall-rules create dev-ports --allow=tcp:8443 --source-ranges=0.0.0.0/0 && cd ~/speaking-with-a-webpage/01-hello-https && mvn clean jetty:run" 
