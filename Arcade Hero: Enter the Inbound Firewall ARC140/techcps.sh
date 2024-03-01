
gcloud compute firewall-rules create default-allow-inbound --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=staging-vm
