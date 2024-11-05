
ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

REGION="${ZONE%-*}"

External_IP=$(gcloud compute instances describe cls-vm --zone $ZONE --project $DEVSHELL_PROJECT_ID --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

gsutil mb -p $DEVSHELL_PROJECT_ID -c STANDARD -l $REGION -b on gs://scc-export-bucket-$DEVSHELL_PROJECT_ID

gsutil uniformbucketlevelaccess set off gs://scc-export-bucket-$DEVSHELL_PROJECT_ID

curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Mitigate%20Threats%20and%20Vulnerabilities%20with%20Security%20Command%20Center%3A%20Challenge%20Lab/findings.jsonl

gsutil cp findings.jsonl gs://scc-export-bucket-$DEVSHELL_PROJECT_ID


echo ""

echo ""

echo "Copy this External IP http://$External_IP:8080"


echo ""

echo ""

echo "Click this link to open [https://console.cloud.google.com/security/web-scanner/scanConfigs/edit?project=$DEVSHELL_PROJECT_ID]"

echo ""
