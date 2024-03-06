
gcloud auth list
gcloud config list project
gcloud config set compute/zone $ZONE

gcloud services enable container.googleapis.com

gcloud container clusters create fancy-cluster --num-nodes 3

gcloud compute instances list

cd ~

git clone https://github.com/googlecodelabs/monolith-to-microservices.git

cd ~/monolith-to-microservices

./setup.sh

nvm install --lts

gcloud services enable cloudbuild.googleapis.com

cd ~/monolith-to-microservices/monolith

gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:1.0.0 .

kubectl create deployment monolith --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:1.0.0

kubectl get all

kubectl expose deployment monolith --type=LoadBalancer --port 80 --target-port 8080

kubectl get service

kubectl scale deployment monolith --replicas=3

kubectl get all

cd ~/monolith-to-microservices/react-app/src/pages/Home
mv index.js.new index.js

cat ~/monolith-to-microservices/react-app/src/pages/Home/index.js

cd ~/monolith-to-microservices/react-app
npm run build:monolith

cd ~/monolith-to-microservices/monolith

gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:2.0.0 .

kubectl set image deployment/monolith monolith=gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:2.0.0

kubectl get pods

