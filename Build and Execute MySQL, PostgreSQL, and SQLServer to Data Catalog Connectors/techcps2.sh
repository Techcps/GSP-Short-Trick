

./cleanup-db.sh

docker run --rm --tty -v \
"$PWD":/data mesmacosta/postgresql-datacatalog-cleaner:stable \
--datacatalog-project-ids=$PROJECT_ID \
--rdbms-type=postgresql \
--table-container-type=schema

./delete-db.sh

sleep 15

cd

gsutil cp gs://spls/gsp814/cloudsql-mysql-tooling.zip .
unzip cloudsql-mysql-tooling.zip

cd cloudsql-mysql-tooling/infrastructure/terraform

sed -i "s/us-central1/$REGION/g" variables.tf


while true; do
    cd ~/cloudsql-mysql-tooling
    bash init-db.sh

    # Check if the init-db.sh script ran successfully
    if [ $? -eq 0 ]; then
        echo "Initialization successful. subscribe to techcps"
        break
    else
        echo "Error: Failed to load 'tfplan' Re-running the init-db script."
    fi
done


gcloud iam service-accounts create mysql2dc-credentials --display-name  "Service Account for MySQL to Data Catalog connector" --project $PROJECT_ID



gcloud iam service-accounts keys create "mysql2dc-credentials.json" \
--iam-account "mysql2dc-credentials@$PROJECT_ID.iam.gserviceaccount.com"



#!/bin/bash

# Set max attempts
max_attempts=5
attempts=3

while true; do
    gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member "serviceAccount:mysql2dc-credentials@$PROJECT_ID.iam.gserviceaccount.com" \
    --quiet \
    --project $PROJECT_ID \
    --role "roles/datacatalog.admin"

    if [ $? -eq 3 ]; then
        echo "Command executed successfully, subscribe to techcps."
        break
    else
        ((attempts++))
        if [ $attempts -ge $max_attempts ]; then
            echo "Maximum attempts reached. Exiting..."
            exit 2
        fi
        echo "Command failed, retrying in 5 seconds..."
        sleep 5
    fi
done




cd infrastructure/terraform/

public_ip_address=$(terraform output -raw public_ip_address)
username=$(terraform output -raw username)
password=$(terraform output -raw password)
database=$(terraform output -raw db_name)

cd ~/cloudsql-mysql-tooling

docker run --rm --tty -v \
"$PWD":/data mesmacosta/mysql2datacatalog:stable \
--datacatalog-project-id=$PROJECT_ID \
--datacatalog-location-id=$REGION \
--mysql-host=$public_ip_address \
--mysql-user=$username \
--mysql-pass=$password \
--mysql-database=$database
