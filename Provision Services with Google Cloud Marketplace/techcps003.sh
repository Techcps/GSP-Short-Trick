
export ZONE=$(gcloud compute instances list --filter="name=nginxstack-1-vm" --format="value(zone)")


cat > cp.sh <<'EOF_CP'

ps aux | grep nginx

EOF_CP

gcloud compute scp cp.sh nginxstack-1-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh nginxstack-1-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp.sh"

