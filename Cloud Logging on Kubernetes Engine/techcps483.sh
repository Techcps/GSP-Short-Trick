

export REGION="${ZONE%-*}"

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set project $DEVSHELL_PROJECT_ID


git clone https://github.com/GoogleCloudPlatform/gke-logging-sinks-demo

sleep 10

cd gke-logging-sinks-demo

sleep 10

gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE


sed -i 's/  version = "~> 2.11.0"/  version = "~> 2.19.0"/g' terraform/provider.tf

sed -i 's/  filter      = "resource.type = container"/  filter      = "resource.type = k8s_container"/g' terraform/main.tf


make create
make validate


# Please like share & subscribe to Techcps https://www.youtube.com/@techcps
gcloud logging read "resource.type=k8s_container AND resource.labels.cluster_name=stackdriver-logging" --project=$PROJECT_ID

# run the specific query
gcloud logging read "resource.type=k8s_container AND resource.labels.cluster_name=stackdriver-logging" --project=$PROJECT_ID --format=json



gcloud logging sinks create techcps \
    bigquery.googleapis.com/projects/$PROJECT_ID/datasets/bq_logs \
    --log-filter='resource.type="k8s_container" 
resource.labels.cluster_name="stackdriver-logging"' \
    --include-children \
    --format='json'


sleep 17



bq query --use_legacy_sql=false \
"
SELECT * FROM \`$DEVSHELL_PROJECT_ID.gke_logs_dataset.diagnostic_log_*\`
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', CURRENT_DATE() - INTERVAL 1 DAY) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
"
