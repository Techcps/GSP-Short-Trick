
gcloud auth list
gcloud services enable datacatalog.googleapis.com --project=$DEVSHELL_PROJECT_ID

gsutil cp gs://spls/gsp814/cloudsql-sqlserver-tooling.zip .
unzip cloudsql-sqlserver-tooling.zip

cd cloudsql-sqlserver-tooling/infrastructure/terraform

sed -i "s/us-central1/$REGION/g" variables.tf

#!/bin/bash

while true; do
    cd ~/cloudsql-sqlserver-tooling
    bash init-db.sh

    # Check if the init-db.sh script ran successfully
    if [ $? -eq 0 ]; then
        echo "Initialization successful. subscribe to techcps"
        break
    else
        echo "Error: Failed to load 'tfplan' Re-running the init-db script."
    fi
done

