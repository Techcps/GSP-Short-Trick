

gcloud auth list

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

gsutil -m cp -r gs://spls/gsp233/* .

cd tf-gke-k8s-service-lb

terraform init

terraform apply -var="region=$REGION" -var="location=$ZONE" --auto-approve


