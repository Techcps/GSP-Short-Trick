
gcloud auth list

gcloud dataplex lakes create customer-info-lake --location=$REGION --display-name="Customer Info Lake"

gcloud dataplex zones create customer-raw-zone --location=$REGION --display-name="Customer Raw Zone" --lake=customer-info-lake --type=RAW --resource-location-type=SINGLE_REGION

