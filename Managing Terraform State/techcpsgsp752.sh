
gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)

cat > main.tf <<EOF
provider "google" {
  project     = "$PROJECT_ID"
  region      = "$REGION"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "$PROJECT_ID"
  location    = "US"
  uniform_bucket_level_access = true
}
terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}
EOF

terraform init
terraform apply --auto-approve
terraform show

cat > main.tf <<EOF
provider "google" {
  project     = "$PROJECT_ID"
  region      = "$REGION"
}
resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "$PROJECT_ID"
  location    = "US"
  uniform_bucket_level_access = true
}
terraform {
  backend "gcs" {
    bucket  = "$PROJECT_ID"
    prefix  = "terraform/state"
  }
}
EOF

yes | terraform init -migrate-state
gsutil label ch -l "key:value" gs://$PROJECT_ID
terraform refresh

