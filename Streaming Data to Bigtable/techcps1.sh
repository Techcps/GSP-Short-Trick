

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud bigtable instances create sandiego \
--display-name="San Diego Traffic Sensors" \
--cluster-storage-type=SSD \
--cluster-config=id=sandiego-traffic-sensors-c1,zone=$ZONE,nodes=1


echo project = `gcloud config get-value project` \
    >> ~/.cbtrc

echo instance = sandiego \
    >> ~/.cbtrc

cat ~/.cbtrc

cbt createtable current_conditions \
    families="lane"

cat > cp_disk.sh <<'EOF_CP'

ls /training

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

source /training/project_env.sh

/training/sensor_magic.sh

EOF_CP

export ZONE=$(gcloud compute instances list training-vm --format 'csv[no-heading](zone)')

gcloud compute scp cp_disk.sh training-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh training-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp_disk.sh"

