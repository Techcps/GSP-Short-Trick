


gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

cat > cp1_disk.sh <<'EOF_CP'

ls /training

source /training/project_env.sh

cd ~/training-data-analyst/courses/streaming/process/sandiego

sed -i 's/\$REGION/us-east4/' run_oncloud.sh

./run_oncloud.sh $DEVSHELL_PROJECT_ID $BUCKET CurrentConditions --bigtable

EOF_CP

export ZONE=$(gcloud compute instances list training-vm --format 'csv[no-heading](zone)')

gcloud compute scp cp1_disk.sh training-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh training-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp1_disk.sh"

