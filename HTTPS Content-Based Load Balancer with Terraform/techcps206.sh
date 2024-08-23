
gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

git clone https://github.com/GoogleCloudPlatform/terraform-google-lb-http.git

cd ~/terraform-google-lb-http/examples/multi-backend-multi-mig-bucket-https-lb

rm -rf main.tf

wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/HTTPS%20Content-Based%20Load%20Balancer%20with%20Terraform/main.tf


terraform init

terraform plan -var project=$DEVSHELL_PROJECT_ID
ls
terraform apply -var project=$DEVSHELL_PROJECT_ID -auto-approve


sleep 10

EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)
echo https://${EXTERNAL_IP}

