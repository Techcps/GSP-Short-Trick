
gcloud auth list
gcloud config list project

# Enable the Cloud Dataplex API
gcloud services enable dataplex.googleapis.com

# Create a lake
gcloud alpha dataplex lakes create sensors --location=$REGION --labels=k1=z1,k2=z2,k3=z3 

# Task 1 is completed
# Add a zone to your lake
gcloud alpha dataplex zones create temperature-raw-data --location=$REGION --lake=sensors --resource-location-type=SINGLE_REGION --type=RAW
gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID

# Task 2 is completed
# Attach an asset to a zone
gcloud dataplex assets create measurements --location=$REGION --lake=sensors --zone=temperature-raw-data --resource-type=STORAGE_BUCKET --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID

# Task 3 is completed
# Delete assets, zones, and lakes
gcloud dataplex assets delete measurements --zone=temperature-raw-data --location=$REGION --lake=sensors --quiet

gcloud dataplex zones delete temperature-raw-data --lake=sensors --location=$REGION --quiet

gcloud dataplex lakes delete sensors --location=$REGION --quiet

