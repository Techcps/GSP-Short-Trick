

gcloud auth list

gcloud config set project $DEVSHELL_PROJECT_ID

gcloud services enable dataplex.googleapis.com storage.googleapis.com dataproc.googleapis.com datacatalog.googleapis.com

sleep 15

gcloud dataplex lakes create sales-lake --location=$REGION --project=$DEVSHELL_PROJECT_ID --display-name="Sales Lake"

Curated zone named Curated Customer Zone


gcloud dataplex zones create curated-customer-zone --location=$REGION --lake=sales-lake --display-name="Curated Customer Zone" --resource-location-type=SINGLE_REGION --discovery-enabled --type=CURATED --discovery-schedule="0 * * * *"


gcloud dataplex zones create raw-customer-zone --location=$REGION --lake=sales-lake --display-name="Raw Customer Zone" --resource-location-type=SINGLE_REGION --discovery-enabled --type=RAW --discovery-schedule="0 * * * *"



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

echo "Click the below link"

echo "-------------"

echo "Click here to open the link https://console.cloud.google.com/dataplex/lakes/sales-lake;location=$REGION/zones?cloudshell=true&project=$DEVSHELL_PROJECT_ID"


