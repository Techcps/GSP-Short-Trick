

gcloud iam service-accounts create postgresql2dc-credentials --display-name  "Service Account for PostgreSQL to Data Catalog connector" --project $DEVSHELL_PROJECT_ID

gcloud iam service-accounts keys create "postgresql2dc-credentials.json" \
--iam-account "postgresql2dc-credentials@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member "serviceAccount:postgresql2dc-credentials@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --quiet --project $DEVSHELL_PROJECT_ID --role "roles/datacatalog.admin"

cd infrastructure/terraform/

public_ip_address=$(terraform output -raw public_ip_address)
username=$(terraform output -raw username)
password=$(terraform output -raw password)
database=$(terraform output -raw db_name)

cd ~/cloudsql-postgresql-tooling

docker run --rm --tty -v \
"$PWD":/data mesmacosta/postgresql2datacatalog:stable \
--datacatalog-project-id=$DEVSHELL_PROJECT_ID \
--datacatalog-location-id=$REGION \
--postgresql-host=$public_ip_address \
--postgresql-user=$username \
--postgresql-pass=$password \
--postgresql-database=$database

sleep 15

./cleanup-db.sh

docker run --rm --tty -v \
"$PWD":/data mesmacosta/postgresql-datacatalog-cleaner:stable \
--datacatalog-project-ids=$DEVSHELL_PROJECT_ID \
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


gcloud iam service-accounts create mysql2dc-credentials --display-name  "Service Account for MySQL to Data Catalog connector" --project $DEVSHELL_PROJECT_ID

gcloud iam service-accounts keys create "mysql2dc-credentials.json" \
--iam-account "mysql2dc-credentials@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member "serviceAccount:mysql2dc-credentials@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
--quiet \
--project $DEVSHELL_PROJECT_ID \
--role "roles/datacatalog.admin"

cd infrastructure/terraform/

public_ip_address=$(terraform output -raw public_ip_address)
username=$(terraform output -raw username)
password=$(terraform output -raw password)
database=$(terraform output -raw db_name)

cd ~/cloudsql-mysql-tooling

docker run --rm --tty -v \
"$PWD":/data mesmacosta/mysql2datacatalog:stable \
--datacatalog-project-id=$DEVSHELL_PROJECT_ID \
--datacatalog-location-id=$REGION \
--mysql-host=$public_ip_address \
--mysql-user=$username \
--mysql-pass=$password \
--mysql-database=$database

