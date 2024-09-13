variable "devsell_project_id" {
  description = "The project ID"
}

variable "external_ip" {
  description = "The external IP address"
}

provider "google" {
  project = var.devsell_project_id
}

resource "google_monitoring_uptime_check_config" "example" {
  display_name = "techcps"
  timeout      = "60s"

  http_check {
    port           = "80"
    request_method = "GET"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.devsell_project_id
      host       = var.external_ip  # Replace with your external IP
    }
  }

  checker_type = "STATIC_IP_CHECKERS"
}
