

export REGION=${ZONE::-2}
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
gcloud composer environments create composer-advanced-lab --location=$REGION --zone=$ZONE --image-version=composer-1.20.12-airflow-2.4.3 --python-version=3

DAGS_BUCKET=$(gcloud storage buckets list --filter="name:$REGION" --format="value(name)")


gsutil mb -l us gs://$PROJECT_ID-us
gsutil mb -l eu gs://$PROJECT_ID--eu
bq mk --dataset_id=nyc_tlc_EU --location=EU


sudo apt-get install -y virtualenv
python3 -m venv venv
source venv/bin/activate


gcloud composer environments run composer-advanced-lab --location us-central1 variables -- \
set table_list_file_path /home/airflow/gcs/dags/bq_copy_eu_to_us_sample.csv


gcloud composer environments run composer-advanced-lab --location us-central1 variables -- \
set gcs_source_bucket $DEVSHELL_PROJECT_ID-us


gcloud composer environments run composer-advanced-lab --location us-central1 variables -- \
set gcs_dest_bucket $DEVSHELL_PROJECT_ID-us

cd ~
gsutil -m cp -r gs://spls/gsp283/python-docs-samples .
gsutil cp -r python-docs-samples/third_party/apache-airflow/plugins/* gs://$DAGS_BUCKET/plugins
gsutil cp python-docs-samples/composer/workflows/bq_copy_across_locations.py gs://$DAGS_BUCKET/dags
gsutil cp python-docs-samples/composer/workflows/bq_copy_eu_to_us_sample.csv gs://$DAGS_BUCKET/dags

