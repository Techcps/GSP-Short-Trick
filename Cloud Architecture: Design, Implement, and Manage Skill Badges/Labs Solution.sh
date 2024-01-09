
export PROJECT_ID=$(gcloud config get-value project)
gsutil cp gs://$DEVSHELL_PROJECT_ID/echo-web.tar.gz .
tar -xvf echo-web.tar.gz
cd echo-web
cloud container clusters create echo-cluster --num-nodes 2 --zone $ZONE --machine-type e2-standard-2
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/echo-app:v1 .
kubectl create deployment echo-app --image=gcr.io/${PROJECT_ID}/echo-app:v1
kubectl expose deployment echo-web --type LoadBalancer --port 80 --target-port 8000
