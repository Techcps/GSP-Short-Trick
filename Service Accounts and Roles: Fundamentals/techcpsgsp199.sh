

gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

gcloud iam service-accounts create my-sa-123 --display-name "my service account"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:my-sa-123@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/editor

# Create a service account
gcloud iam service-accounts create bigquery-qwiklab --description="please like share & subscribe to techcps" --display-name="bigquery-qwiklab"

# Assign BigQuery Data Viewer role
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:bigquery-qwiklab@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/bigquery.dataViewer"

# Assign BigQuery User role
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:bigquery-qwiklab@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/bigquery.user"

# Create a VM instance with the following information:
gcloud compute instances create bigquery-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=bigquery-qwiklab@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --create-disk=auto-delete=yes,boot=yes,device-name=bigquery-instance,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud compute ssh "bigquery-instance" --zone "$ZONE" --quiet

#  Install the necessary dependencies by running the following commands
sudo apt-get update
sudo apt-get install -y git python3-pip
pip3 install --upgrade pip
pip3 install google-cloud-bigquery
pip3 install pyarrow
pip3 install pandas
pip3 install db-dtypes

# create the example Python file

# query.py
splitter
echo "query.py"
splitter
cat << EOF_END
from google.auth import compute_engine
from google.cloud import bigquery
credentials = compute_engine.Credentials(
    service_account_email='bigquery-qwiklab@$PROJECT_ID.iam.gserviceaccount.com')
query = '''
SELECT
  year,
  COUNT(1) as num_babies
FROM
  publicdata.samples.natality
WHERE
  year > 2000
GROUP BY
  year
'''
client = bigquery.Client(
    project='$PROJECT_ID',
    credentials=credentials)
print(client.query(query).to_dataframe())
EOF_END

# The application now uses the permissions that are associated with this service account. Run the query with the following Python command
python3 query.py

