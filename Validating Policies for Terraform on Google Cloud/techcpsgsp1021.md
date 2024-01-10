
# Validating Policies for Terraform on Google Cloud [GSP1021]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)


```
gcloud auth list
gcloud config list project
git clone https://github.com/GoogleCloudPlatform/policy-library.git
cd policy-library/
cp samples/iam_service_accounts_only.yaml policies/constraints
cat policies/constraints/iam_service_accounts_only.yaml
```
```
touch main.tf
```
## Open the policy-library/main.tf file and copy the following code into it:

* Replace <YOUR PROJECT ID> with Project ID and <USER> with Lab username

```
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 3.84"
    }
  }
}

resource "google_project_iam_binding" "sample_iam_binding" {
  project = "<YOUR PROJECT ID>"
  role    = "roles/viewer"

  members = [
    "user:<USER>"
  ]
}
```
```
terraform init
```
```
terraform plan -out=test.tfplan
terraform show -json ./test.tfplan > ./tfplan.json
sudo apt-get install google-cloud-sdk-terraform-tools
gcloud beta terraform vet tfplan.json --policy-library=.
terraform plan -out=test.tfplan
gcloud beta terraform vet tfplan.json --policy-library=.
terraform apply test.tfplan
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
