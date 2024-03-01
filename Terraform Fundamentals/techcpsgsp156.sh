
gcloud auth list
terraform

cat > instance.tf <<EOF_END
resource "google_compute_instance" "terraform" {
  project      = "$DEVSHELL_PROJECT_ID"
  name         = "terraform"
  machine_type = "e2-medium"
  zone         = "$ZONE"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
EOF_END

ls
terraform init
terraform plan
terraform apply
