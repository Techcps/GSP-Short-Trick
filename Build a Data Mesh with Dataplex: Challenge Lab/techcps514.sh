


# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the REGION: ${RESET}" REGION
read -p "${YELLOW}${BOLD}Enter the USER_ID_2: ${RESET}" USER_ID_2

export REGION USER_ID_2

gcloud auth list

gcloud config set project $DEVSHELL_PROJECT_ID

gcloud services enable dataplex.googleapis.com storage.googleapis.com dataproc.googleapis.com datacatalog.googleapis.com

sleep 15

gcloud dataplex lakes create sales-lake --location=$REGION --project=$DEVSHELL_PROJECT_ID --display-name="Sales Lake"

gcloud dataplex zones create curated-customer-zone --location=$REGION --lake=sales-lake --display-name="Curated Customer Zone" --resource-location-type=SINGLE_REGION --discovery-enabled --type=CURATED --discovery-schedule="0 * * * *"

gcloud dataplex zones create raw-customer-zone --location=$REGION --lake=sales-lake --display-name="Raw Customer Zone" --resource-location-type=SINGLE_REGION --discovery-enabled --type=RAW --discovery-schedule="0 * * * *"

gcloud dataplex assets create customer-engagements --location=$REGION --lake=sales-lake --display-name="Customer Engagements" --resource-type=STORAGE_BUCKET --discovery-enabled --zone=raw-customer-zone --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID-customer-online-sessions

gcloud dataplex assets create customer-orders --location=$REGION --lake=sales-lake --display-name="Customer Orders" --resource-type=BIGQUERY_DATASET --discovery-enabled --zone=curated-customer-zone --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_orders \
  
gcloud data-catalog tag-templates create protected_customer_data_template --location=$REGION --display-name="Protected Customer Data Template" --field=id=raw_data_flag,display-name="Raw Data Flag",type='enum(Yes|No)',required=TRUE --field=id=protected_contact_information_flag,display-name="Protected Contact Information Flag",type='enum(Yes|No)',required=TRUE

gcloud dataplex assets add-iam-policy-binding customer-engagements --location=$REGION --lake=sales-lake --zone=raw-customer-zone --role=roles/dataplex.dataWriter --member=user:$USER_ID_2


cat > dq-customer-orders.yaml <<EOF_CP
metadata_registry_defaults:
  dataplex:
    projects: $DEVSHELL_PROJECT_ID
    locations: $REGION
    lakes: sales-lake
    zones: curated-customer-zone
row_filters:
  NONE:
    filter_sql_expr: |-
      True
rule_dimensions:
  - completeness
rules:
  NOT_NULL:
    rule_type: NOT_NULL
    dimension: completeness
rule_bindings:
  VALID_CUSTOMER:
    entity_uri: bigquery://projects/$DEVSHELL_PROJECT_ID/datasets/customer_orders/tables/ordered_items
    column_id: user_id
    row_filter_id: NONE
    rule_ids:
      - NOT_NULL
  VALID_ORDER:
    entity_uri: bigquery://projects/$DEVSHELL_PROJECT_ID/datasets/customer_orders/tables/ordered_items
    column_id: order_id
    row_filter_id: NONE
    rule_ids:
      - NOT_NULL

EOF_CP


gsutil cp dq-customer-orders.yaml gs://$DEVSHELL_PROJECT_ID-dq-config

echo "Please subscribe to techcps[https://www.youtube.com/@techcps]"

echo "-------------"

echo ""

echo "Click here to open the link https://console.cloud.google.com/dataplex/search?project=$DEVSHELL_PROJECT_ID&q=Raw%20Customer%20Zone&qSystems=DATAPLEX"

echo ""

echo "Click here to open the link https://console.cloud.google.com/dataplex/process/create-task?project=$DEVSHELL_PROJECT_ID"


echo ""

echo ""



