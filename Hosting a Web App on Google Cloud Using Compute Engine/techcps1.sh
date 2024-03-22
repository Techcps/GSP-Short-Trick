gcloud compute http-health-checks create fancy-fe-frontend-hc \
--request-path / \
--port 8080

gcloud compute http-health-checks create fancy-be-orders-hc \
--request-path /api/orders \
--port 8081

gcloud compute http-health-checks create fancy-be-products-hc \
--request-path /api/products \
--port 8082

gcloud compute backend-services create fancy-fe-frontend --http-health-checks fancy-fe-frontend-hc --port-name frontend --global

gcloud compute backend-services create fancy-be-orders --http-health-checks fancy-be-orders-hc --port-name orders --global

gcloud compute backend-services create fancy-be-products --http-health-checks fancy-be-products-hc --port-name products --global

gcloud compute backend-services add-backend fancy-fe-frontend --instance-group-zone=$ZONE --instance-group fancy-fe-mig --global

gcloud compute backend-services add-backend fancy-be-orders --instance-group-zone=$ZONE --instance-group fancy-be-mig --global

gcloud compute backend-services add-backend fancy-be-products --instance-group-zone=$ZONE --instance-group fancy-be-mig --global

gcloud compute url-maps create fancy-map --default-service fancy-fe-frontend

gcloud compute url-maps add-path-matcher fancy-map --default-service fancy-fe-frontend --path-matcher-name orders --path-rules "/api/orders=fancy-be-orders,/api/products=fancy-be-products"

gcloud compute target-http-proxies create fancy-proxy --url-map fancy-map

gcloud compute forwarding-rules create fancy-http-rule --global --target-http-proxy fancy-proxy --ports 80

cd ~/monolith-to-microservices/react-app/

gcloud compute forwarding-rules list --global

cat > .env <<EOF
REACT_APP_ORDERS_URL=http://$EXTERNAL_IP_BK:8081/api/orders
REACT_APP_PRODUCTS_URL=http://$EXTERNAL_IP_BK:8082/api/products

REACT_APP_ORDERS_URL=http://$EXTERNAL_IP/api/orders
REACT_APP_PRODUCTS_URL=http://$EXTERNAL_IP/api/products
EOF

cd ~

cd ~/monolith-to-microservices/react-app
npm install && npm run-script build

cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/

gcloud compute instance-groups managed rolling-action replace fancy-fe-mig --zone=$ZONE --max-unavailable 100%


gcloud compute instance-groups managed set-autoscaling \
fancy-fe-mig \
--zone=$ZONE --max-num-replicas 2 --target-load-balancing-utilization 0.60

gcloud compute instance-groups managed set-autoscaling \
fancy-be-mig \
--zone=$ZONE --max-num-replicas 2 --target-load-balancing-utilization 0.60

gcloud compute backend-services update fancy-fe-frontend --enable-cdn --global

gcloud compute instances set-machine-type frontend --zone=$ZONE --machine-type e2-small

gcloud compute instance-templates create fancy-fe-new --region=$REGION --source-instance=frontend --source-instance-zone=$ZONE

gcloud compute instance-groups managed rolling-action start-update fancy-fe-mig --zone=$ZONE --version template=fancy-fe-new

cd ~/monolith-to-microservices/react-app/src/pages/Home
mv index.js.new index.js

cat ~/monolith-to-microservices/react-app/src/pages/Home/index.js

cd ~/monolith-to-microservices/react-app
npm install && npm run-script build

cd ~
rm -rf monolith-to-microservices/*/node_modules
gsutil -m cp -r monolith-to-microservices gs://fancy-store-$DEVSHELL_PROJECT_ID/

gcloud compute instance-groups managed rolling-action replace fancy-fe-mig --zone=$ZONE --max-unavailable=100%

