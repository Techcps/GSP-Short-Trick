
gcloud services enable \
  dataplex.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud dataplex lakes create ecommerce --location=$REGION --display-name="Ecommerce" --description="subscribe to techcps"

gcloud dataplex zones create orders-curated-zone --location=$REGION --lake=ecommerce --display-name="Orders Curated Zone" --resource-location-type=SINGLE_REGION --type=CURATED --discovery-enabled --discovery-schedule="0 * * * *"

bq mk --location=$REGION --dataset orders 

gcloud dataplex assets create orders-curated-dataset --location=$REGION --lake=ecommerce --zone=orders-curated-zone --display-name="Orders Curated Dataset" --resource-type=BIGQUERY_DATASET --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/orders --discovery-enabled 

gcloud dataplex assets delete orders-curated-dataset --location=$REGION --zone=orders-curated-zone --lake=ecommerce --quiet

gcloud dataplex zones delete orders-curated-zone --location=$REGION --lake=ecommerce --quiet

gcloud dataplex lakes delete ecommerce --location=$REGION --quiet 

