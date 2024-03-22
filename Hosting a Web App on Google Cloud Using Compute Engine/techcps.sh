
gcloud auth list

gcloud services enable compute.googleapis.com --project=$DEVSHELL_PROJECT_ID

gsutil mb gs://fancy-store-$DEVSHELL_PROJECT_ID

git clone https://github.com/googlecodelabs/monolith-to-microservices.git
cd ~/monolith-to-microservices
./setup.sh
nvm install --lts

curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Hosting%20a%20Web%20App%20on%20Google%20Cloud%20Using%20Compute%20Engine/startup-script.sh

gsutil cp ~/monolith-to-microservices/startup-script.sh gs://fancy-store-$DEVSHELL_PROJECT_ID

cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/

gcloud compute instances create backend --zone=$ZONE --machine-type=e2-standard-2 --tags=backend --metadata=startup-script-url=https://storage.googleapis.com/fancy-store-$DEVSHELL_PROJECT_ID/startup-script.sh

gcloud compute instances list

cat > .env <<EOF_CP
REACT_APP_ORDERS_URL=http://$EXTERNAL_IP_BK:8081/api/orders
REACT_APP_PRODUCTS_URL=http://$EXTERNAL_IP_BK:8082/api/products
EOF_CP

cd ~/monolith-to-microservices/react-app
npm install && npm run-script build

cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/

gcloud compute instances create frontend --zone=$ZONE --machine-type=e2-standard-2 --tags=frontend --metadata=startup-script-url=https://storage.googleapis.com/fancy-store-$DEVSHELL_PROJECT_ID/startup-script.sh

gcloud compute firewall-rules create fw-fe --allow tcp:8080 --target-tags=frontend

gcloud compute firewall-rules create fw-be --allow tcp:8081-8082 --target-tags=backend

gcloud compute instances list

# Task 4 is completed & like share and subscribe to techcps

gcloud compute instances stop frontend --zone=$ZONE

gcloud compute instances stop backend --zone=$ZONE

gcloud compute instance-templates create fancy-fe --source-instance-zone=$ZONE --source-instance=frontend

gcloud compute instance-templates create fancy-be --source-instance-zone=$ZONE --source-instance=backend

gcloud compute instance-templates list

gcloud compute instances delete backend --zone=$ZONE --quiet

gcloud compute instance-groups managed create fancy-fe-mig --zone=$ZONE --base-instance-name fancy-fe --size 2 --template fancy-fe

gcloud compute instance-groups managed create fancy-be-mig --zone=$ZONE --base-instance-name fancy-be --size 2 --template fancy-be

gcloud compute instance-groups set-named-ports fancy-fe-mig --zone=$ZONE --named-ports frontend:8080

gcloud compute instance-groups set-named-ports fancy-be-mig --zone=$ZONE --named-ports orders:8081,products:8082

gcloud compute health-checks create http fancy-fe-hc --port 8080 --check-interval 30s --healthy-threshold 1 --timeout 10s --unhealthy-threshold 3

gcloud compute health-checks create http fancy-be-hc --port 8081 --request-path=/api/orders --check-interval 30s --healthy-threshold 1 --timeout 10s --unhealthy-threshold 3

gcloud compute firewall-rules create allow-health-check --allow tcp:8080-8081 --source-ranges 130.211.0.0/22,35.191.0.0/16 --network default

gcloud compute instance-groups managed update fancy-fe-mig --zone=$ZONE --health-check fancy-fe-hc --initial-delay 300

gcloud compute instance-groups managed update fancy-be-mig --zone=$ZONE --health-check fancy-be-hc --initial-delay 300

