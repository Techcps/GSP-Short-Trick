

gcloud compute firewall-rules create iperf-testing --direction=INGRESS --network=default --action=ALLOW --priority=1000 --rules=tcp:5001,udp:5001 --source-ranges=0.0.0.0/0 --target-tags=all-instances


echo "https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/iperf-testing?project=$DEVSHELL_PROJECT_ID"


