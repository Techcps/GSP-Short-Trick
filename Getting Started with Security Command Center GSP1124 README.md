
# Getting Started with Security Command Center [GSP1124]

# If you consider that the video helped you to complete your lab, so please do like and subscribe. https://www.youtube.com/@techcps

* In the GCP Console open the Cloud Shell and enter the following commands:

```
gcloud auth list
gcloud config list project
# Enable the Google Cloud Security Command Center service
gcloud services enable securitycenter.googleapis.com
sleep 17
gcloud scc muteconfigs create muting-pga-findings \
--project=$DEVSHELL_PROJECT_ID \
--description="Mute rule for VPC Flow Logs" \
--filter="category=\"FLOW_LOGS_DISABLED\""
gcloud compute networks create scc-lab-net --subnet-mode=auto
gcloud compute firewall-rules update default-allow-rdp --source-ranges=35.235.240.0/20
gcloud compute firewall-rules update default-allow-ssh --source-ranges=35.235.240.0/20
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)