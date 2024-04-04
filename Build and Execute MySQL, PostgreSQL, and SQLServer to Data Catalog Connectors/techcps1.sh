

./cleanup-db.sh


docker run --rm --tty -v \
"$PWD":/data mesmacosta/sqlserver-datacatalog-cleaner:stable \
--datacatalog-project-ids=$PROJECT_ID \
--rdbms-type=sqlserver \
--table-container-type=schema


./delete-db.sh

sleep 5 

cd

gsutil cp gs://spls/gsp814/cloudsql-postgresql-tooling.zip .
unzip cloudsql-postgresql-tooling.zip

cd cloudsql-postgresql-tooling/infrastructure/terraform


sed -i "s/us-central1/$REGION/g" variables.tf


while true; do
    cd ~/cloudsql-postgresql-tooling
    bash init-db.sh

    # Check if the init-db.sh script ran successfully
    if [ $? -eq 0 ]; then
        echo "Initialization successful. subscribe to techcps"
        break
    else
        echo "Error: Failed to load 'tfplan' Re-running the init-db script."
    fi
done

