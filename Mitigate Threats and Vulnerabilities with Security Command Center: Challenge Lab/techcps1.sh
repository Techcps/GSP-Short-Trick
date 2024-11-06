
ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

gcloud scc muteconfigs create muting-flow-log-findings --project=$DEVSHELL_PROJECT_ID --location=global --description="Rule for muting VPC Flow Logs" --filter="category=\"FLOW_LOGS_DISABLED\"" --type=STATIC

gcloud scc muteconfigs create muting-audit-logging-findings --project=$DEVSHELL_PROJECT_ID --location=global --description="Rule for muting audit logs" --filter="category=\"AUDIT_LOGGING_DISABLED\"" --type=STATIC

gcloud scc muteconfigs create muting-admin-sa-findings --project=$DEVSHELL_PROJECT_ID --location=global --description="Rule for muting admin service account findings" --filter="category=\"ADMIN_SERVICE_ACCOUNT\"" --type=STATIC

sleep 20

gcloud compute firewall-rules delete default-allow-rdp  --quiet && gcloud compute firewall-rules delete default-allow-ssh --quiet

gcloud compute firewall-rules create default-allow-rdp --source-ranges=35.235.240.0/20 --allow=tcp:3389 --priority=65534 --description="Allow HTTP traffic from 35.235.240.0/20"

gcloud compute firewall-rules create default-allow-ssh --source-ranges=35.235.240.0/20 --allow=tcp:22 --priority=65534 --description="Allow HTTP traffic from 35.235.240.0/20"

echo ""

echo ""

echo "Click this link to open [https://console.cloud.google.com/compute/instancesEdit/zones/$ZONE/instances/cls-vm?project=$DEVSHELL_PROJECT_ID]"

echo ""

