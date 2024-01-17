

gcloud auth list

gcloud config list project

gcloud services enable dataplex.googleapis.com

gcloud alpha dataplex lakes create sensors --location=$REGION --labels=k1=z1,k2=z2,k3=z3 

gcloud alpha dataplex zones create temperature-raw-data --location=$REGION --lake=sensors --resource-location-type=SINGLE_REGION --type=RAW

gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID

gcloud dataplex assets create measurements --location=$REGION --lake=sensors --zone=temperature-raw-data --resource-type=STORAGE_BUCKET --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID

gcloud dataplex assets delete measurements --zone=temperature-raw-data --location=$REGION --lake=sensors --quiet

gcloud dataplex zones delete temperature-raw-data --lake=sensors --location=$REGION --quiet

gcloud dataplex lakes delete sensors --location=$REGION --quiet
