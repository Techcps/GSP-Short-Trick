

export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET_NAME=$PROJECT_ID

bq query --use_legacy_sql=false 'SELECT start_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY start_station_name ORDER BY num DESC'

bq query --use_legacy_sql=false 'SELECT end_station_name, COUNT(*) AS num FROM `bigquery-public-data.london_bicycles.cycle_hire` GROUP BY end_station_name ORDER BY num DESC'

gsutil mb gs://$PROJECT_ID

curl -O https://github.com/Techcps/GSP-Short-Trick/blob/main/Introduction%20to%20SQL%20for%20BigQuery%20and%20Cloud%20SQL/start_station_data.csv

curl -O https://github.com/Techcps/GSP-Short-Trick/blob/main/Introduction%20to%20SQL%20for%20BigQuery%20and%20Cloud%20SQL/end_station_data.csv

gsutil cp *start_station_data.csv gs://$PROJECT_ID/
gsutil cp *end_station_data.csv gs://$PROJECT_ID/

gcloud sql instances create my-demo --tier=db-n1-standard-2 --region=$REGION --root-password=Password

gcloud sql databases create bike --instance=my-demo
