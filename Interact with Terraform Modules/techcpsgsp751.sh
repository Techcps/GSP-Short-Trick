
git clone https://github.com/terraform-google-modules/terraform-google-network
cd terraform-google-network
git checkout tags/v6.0.1 -b v6.0.1

gcloud config list --format 'value(core.project)'

cd examples/simple_project

cat > variables.tf <<EOF
variable "project_id" {
  description = "The project ID to host the network in"
  default     = "$DEVSHELL_PROJECT_ID"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "example-vpc"
}
EOF

terraform init
terraform apply --auto-approve
terraform destroy --auto-approve
cd ~
rm -rd terraform-google-network -f

cd ~
gsutil mb gs://$DEVSHELL_PROJECT_ID
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/index.html > index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/blob/master/modules/aws-s3-static-website-bucket/www/error.html > error.html

gsutil cp *.html gs://$DEVSHELL_PROJECT_ID
