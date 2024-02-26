
export REGION=${ZONE%-*}

gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

git clone https://github.com/GoogleCloudPlatform/gke-tracing-demo
cd gke-tracing-demo
cd terraform
sed -i '/version = "~> 2.10.0"/d' provider.tf
terraform init
../scripts/generate-tfvars.sh
terraform plan
terraform apply -auto-approve

kubectl apply -f tracing-demo-deployment.yaml
echo http://$(kubectl get svc tracing-demo -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')?string=CustomMessage
