
git clone https://github.com/terraform-google-modules/terraform-google-network
cd terraform-google-network
git checkout tags/v6.0.1 -b v6.0.1

gcloud config list --format 'value(core.project)'

cd examples/simple_project

cat > variables.tf <<EOF_END
variable "project_id" {
  description = "The project ID to host the network in"
  default     = "$DEVSHELL_PROJECT_ID"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "example-vpc"
}
EOF_END

terraform init
terraform apply --auto-approve
terraform destroy --auto-approve
cd ~
rm -rd terraform-google-network -f
