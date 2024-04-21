

export PROJECT_ID=$(gcloud config get-value project)

gcloud container clusters create echo-cluster --project $PROJECT_ID --zone=$ZONE --machine-type=e2-standard-2 --num-nodes=2

gsutil cp gs://${PROJECT_ID}/echo-web.tar.gz .

tar -xvzf echo-web.tar.gz

cd echo-web

gcloud builds submit --tag gcr.io/{$PROJECT_ID}/echo-app:v1 .

docker push gcr.io/${PROJECT_ID}/echo-app:v1

kubectl create deployment echo-web --image=gcr.io/$PROJECT_ID/echo-web:v1 --port=8000

kubectl expose deployment echo-web --type=LoadBalancer --port=80 --target-port=8000

