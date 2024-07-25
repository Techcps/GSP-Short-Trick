

gcloud auth list
gcloud config list project
gcloud config set compute/zone $ZONE
export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

gcloud services enable container.googleapis.com cloudbuild.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 5

git clone https://github.com/googlecodelabs/monolith-to-microservices.git

cd ~/monolith-to-microservices
./setup.sh


cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/${MONOLITH}:1.0.0 .


gcloud container clusters create $CLUSTER --num-nodes 3

kubectl create deployment $MONOLITH --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$MONOLITH:1.0.0

kubectl expose deployment $MONOLITH --type=LoadBalancer --port 80 --target-port 8080


cd ~/monolith-to-microservices/microservices/src/orders
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/$ORDERS:1.0.0 .


cd ~/monolith-to-microservices/microservices/src/products
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/$PRODUCTS:1.0.0 .


kubectl create deployment $ORDERS --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$ORDERS:1.0.0

kubectl expose deployment $ORDERS --type=LoadBalancer --port 80 --target-port 8081


kubectl create deployment $PRODUCTS --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$PRODUCTS:1.0.0
kubectl expose deployment $PRODUCTS --type=LoadBalancer --port 80 --target-port 8082


cd ~/monolith-to-microservices/react-app
cd ~/monolith-to-microservices/microservices/src/frontend


gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/$FRONTEND:1.0.0 .


kubectl create deployment $FRONTEND --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$FRONTEND:1.0.0
kubectl expose deployment $FRONTEND --type=LoadBalancer --port 80 --target-port 8080

echo "Please like, share, and subscribe to Techcps! [https://www.youtube.com/@techcps]"

