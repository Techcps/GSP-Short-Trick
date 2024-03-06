
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
touch main.tf
mkdir -p modules/gcs-static-website-bucket

cd modules/gcs-static-website-bucket
touch website.tf variables.tf outputs.tf

tee -a README.md <<EOF
# GCS static website bucket
This module provisions Cloud Storage buckets configured for static website hosting.
EOF

tee -a LICENSE <<EOF
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
EOF

wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Interact%20with%20Terraform%20Modules/website.tf
wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Interact%20with%20Terraform%20Modules/variables.tf
wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Interact%20with%20Terraform%20Modules/outputs.tf
cd ~
wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Interact%20with%20Terraform%20Modules/main.tf

cat > outputs.tf <<EOF
output "bucket-name" {
  description = "Bucket names."
  value       = "module.gcs-static-website-bucket.bucket"
}
EOF

cat > variables.tf <<EOF
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "$DEVSHELL_PROJECT_ID"
}
variable "name" {
  description = "Name of the buckets to create."
  type        = string
  default     = "$DEVSHELL_PROJECT_ID"
}
EOF

terraform init
terraform apply --auto-approve

cd ~
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/master/modules/aws-s3-static-website-bucket/www/index.html > index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terraform-modules/blob/master/modules/aws-s3-static-website-bucket/www/error.html > error.html

gsutil cp *.html gs://$DEVSHELL_PROJECT_ID
