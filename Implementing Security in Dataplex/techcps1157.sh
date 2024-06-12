
gcloud auth list


gcloud dataplex lakes create customer-info-lake --location=$REGION --display-name="Customer Info Lake"

gcloud dataplex zones create customer-raw-zone --location=$REGION --display-name="Customer Raw Zone" --lake=customer-info-lake --type=RAW --resource-location-type=SINGLE_REGION


echo "Click here to open techcps https://console.cloud.google.com/dataplex/lakes?cloudshell=true&project=$DEVSHELL_PROJECT_ID"


echo "Please like share & subscribe to techcps, https://www.youtube.com/@techcps"


echo "----------------------"

echo "----------------------"

echo "Click here to open techcps https://console.cloud.google.com/storage/browser?referrer=search&project=$DEVSHELL_PROJECT_ID&prefix=&forceOnBucketsSortingFiltering=true"
