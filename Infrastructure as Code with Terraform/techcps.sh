
export REGION=${ZONE%-*}

cat > main.tf << EOF_CP
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "$DEVSHELL_PROJECT_ID"
  region  = "$REGION"
  zone    = "$ZONE"
}

resource "google_compute_instance" "terraform" {
  name         = "terraform"
  machine_type = "e2-micro"
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
EOF_CP

terraform init
terraform plan
terraform apply -auto-approve


cat > main.tf << EOF_CP
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "$DEVSHELL_PROJECT_ID"
  region  = "$REGION"
  zone    = "$ZONE"
}

resource "google_compute_instance" "terraform" {
  name         = "terraform"
  machine_type = "e2-micro"
  tags         = ["web", "dev"]  # Added tags argument
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
EOF_CP

terraform plan
terraform apply -auto-approve

cat > main.tf << EOF_CP
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "$DEVSHELL_PROJECT_ID"
  region  = "$REGION"
  zone    = "$ZONE"
}

resource "google_compute_instance" "terraform" {
  name         = "terraform"
  machine_type = "e2-medium"

  tags         = ["web", "dev"]

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
  allow_stopping_for_update = true
}
EOF_CP

terraform plan
terraform apply -auto-approve

terraform destroy -auto-approve
