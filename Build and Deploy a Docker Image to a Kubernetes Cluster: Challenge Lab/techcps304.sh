
export PROJECT_ID=$(gcloud config get-value project)

gcloud container clusters create echo-cluster --project $PROJECT_ID --zone=$ZONE --machine-type=e2-standard-2 --num-nodes=2

gsutil cp gs://sureskills-ql/challenge-labs/ch04-kubernetes-app-deployment/echo-web.tar.gz .

tar -xvf echo-web.tar.gz

gcloud builds submit --tag gcr.io/$PROJECT_ID/echo-app:v1 .

kubectl create deployment echo-web --image=gcr.io/qwiklabs-resources/echo-app:v1
deployment.apps/echo-web created

kubectl expose deployment echo-web --type=LoadBalancer --port=80 --target-port=8000
service/echo-web exposed

kubectl get svc -w

