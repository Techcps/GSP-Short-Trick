


# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION

# Export variables after collecting input
export REGION

gcloud services enable sqladmin.googleapis.com

gcloud sql instances create my-instance --project=$DEVSHELL_PROJECT_ID --database-version=MYSQL_5_7 --tier=db-n1-standard-1

gcloud sql databases create mysql-db --instance=my-instance --project=$DEVSHELL_PROJECT_ID

bq mk --dataset $DEVSHELL_PROJECT_ID:mysql_db


bq query --use_legacy_sql=false \
"CREATE TABLE \`${DEVSHELL_PROJECT_ID}.mysql_db.info\` (
  name STRING,
  age INT64,
  occupation STRING
);"


cat > employee_info.csv <<EOF_CP
"Sean", 23, "Content Creator"
"Emily", 34, "Cloud Engineer"
"Rocky", 40, "Event coordinator"
"Kate", 28, "Data Analyst"
"Juan", 51, "Program Manager"
"Jennifer", 32, "Web Developer"
EOF_CP


gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil cp employee_info.csv gs://$DEVSHELL_PROJECT_ID/

SERVICE_EMAIL=$(gcloud sql instances describe my-instance --format="value(serviceAccountEmailAddress)")

gsutil iam ch serviceAccount:$SERVICE_EMAIL:roles/storage.admin gs://$DEVSHELL_PROJECT_ID/


