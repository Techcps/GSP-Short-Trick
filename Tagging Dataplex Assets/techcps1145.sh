

gcloud auth list

gcloud services enable dataplex.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud services enable datacatalog.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud dataplex lakes create orders-lake --location=$REGION --display-name="Orders Lake"

gcloud dataplex zones create customer-curated-zone --location=$REGION --lake=orders-lake --display-name="Customer Curated Zone" --resource-location-type=SINGLE_REGION --discovery-enabled --type=CURATED --discovery-schedule="0 * * * *"

gcloud dataplex assets create customer-details-dataset --location=$REGION --lake=orders-lake --zone=customer-curated-zone --display-name="Customer Details Dataset" --resource-type=BIGQUERY_DATASET --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customers --discovery-enabled

gcloud data-catalog tag-templates create protected_data_template --location=$REGION --field=id=protected_data_flag,display-name="Protected Data Flag",type='enum(YES|NO)' --display-name="Protected Data Template"


echo "https://console.cloud.google.com/dataplex/projects/$DEVSHELL_PROJECT_ID/locations/$REGION/entryGroups/@bigquery/entries/cHJvamVjdHMvcXdpa2xhYnMtZ2NwLTAxLWFjZWEyMDNkMDk3Mi9kYXRhc2V0cy9jdXN0b21lcnMvdGFibGVzL2N1c3RvbWVyX2RldGFpbHM?cloudshell=true&project=$DEVSHELL_PROJECT_ID"

