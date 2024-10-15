

echo "Export the variables name correctly"


# Set the below variables name correctly
read -p "Enter LANGUAGE: " LANGUAGE
read -p "Enter LOCAL: " LOCAL
read -p "Enter BIGQUERY_ROLE: " BIGQUERY_ROLE
read -p "Enter CLOUD_STORAGE_ROLE: " CLOUD_STORAGE_ROLE


gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud iam service-accounts create sample-sa --project=$DEVSHELL_PROJECT_ID


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=$BIGQUERY_ROLE


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=$CLOUD_STORAGE_ROLE


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=roles/serviceusage.serviceUsageConsumer

sleep 30


gcloud iam service-accounts keys create sample-sa-key.json --iam-account sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com


export GOOGLE_APPLICATION_CREDENTIALS=${PWD}/sample-sa-key.json


wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick//master/Use%20Machine%20Learning%20APIs%20on%20Google%20Cloud%3A%20Challenge%20Lab/analyze-images-v2.py


sed -i "s/'en'/'${LOCAL}'/g" analyze-images-v2.py


python3 analyze-images-v2.py


python3 analyze-images-v2.py $DEVSHELL_PROJECT_ID $DEVSHELL_PROJECT_ID


bq query --use_legacy_sql=false "SELECT locale,COUNT(locale) as lcount FROM image_classification_dataset.image_text_detail GROUP BY locale ORDER BY lcount DESC"

