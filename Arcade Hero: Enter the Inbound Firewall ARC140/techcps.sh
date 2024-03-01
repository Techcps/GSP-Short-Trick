
gcloud auth list
export PROJECT_ID=$(gcloud info --format="value(config.project)")
firewall-rules create default-allow-inbound --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=staging-vm
