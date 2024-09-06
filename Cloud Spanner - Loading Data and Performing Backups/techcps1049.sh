

gcloud auth list

gcloud config set compute/region $REGION

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID


gcloud spanner databases execute-sql banking-db --instance=banking-instance \
 --sql="INSERT INTO Customer (CustomerId, Name, Location) VALUES ('bdaaaa97-1b4b-4e58-b4ad-84030de92235', 'Richard Nelson', 'Ada Ohio')"

cat > insert.py <<EOF_CP
from google.cloud import spanner
from google.cloud.spanner_v1 import param_types
INSTANCE_ID = "banking-instance"
DATABASE_ID = "banking-db"
spanner_client = spanner.Client()
instance = spanner_client.instance(INSTANCE_ID)
database = instance.database(DATABASE_ID)
def insert_customer(transaction):
    row_ct = transaction.execute_update(
        "INSERT INTO Customer (CustomerId, Name, Location)"
        "VALUES ('b2b4002d-7813-4551-b83b-366ef95f9273', 'Shana Underwood', 'Ely Iowa')"
    )
    print("{} record(s) inserted.".format(row_ct))
database.run_in_transaction(insert_customer)

EOF_CP

python3 insert.py


sleep 60


cat > batch_insert.py <<EOF_CP
from google.cloud import spanner
from google.cloud.spanner_v1 import param_types
INSTANCE_ID = "banking-instance"
DATABASE_ID = "banking-db"
spanner_client = spanner.Client()
instance = spanner_client.instance(INSTANCE_ID)
database = instance.database(DATABASE_ID)
with database.batch() as batch:
    batch.insert(
        table="Customer",
        columns=("CustomerId", "Name", "Location"),
        values=[
        ('edfc683f-bd87-4bab-9423-01d1b2307c0d', 'John Elkins', 'Roy Utah'),
        ('1f3842ca-4529-40ff-acdd-88e8a87eb404', 'Martin Madrid', 'Ames Iowa'),
        ('3320d98e-6437-4515-9e83-137f105f7fbc', 'Theresa Henderson', 'Anna Texas'),
        ('6b2b2774-add9-4881-8702-d179af0518d8', 'Norma Carter', 'Bend Oregon'),
        ],
    )
print("Rows inserted")
EOF_CP


python3 batch_insert.py

sleep 60

gsutil mb gs://$DEVSHELL_PROJECT_ID
touch emptyfile
gsutil cp emptyfile gs://$DEVSHELL_PROJECT_ID/tmp/emptyfile


gcloud services disable dataflow.googleapis.com --force
gcloud services enable dataflow.googleapis.com


sleep 90

gcloud dataflow jobs run spanner-load --gcs-location gs://dataflow-templates-$REGION/latest/GCS_Text_to_Cloud_Spanner --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID/tmp/ --parameters instanceId=banking-instance,databaseId=banking-db,importManifest=gs://cloud-training/OCBL372/manifest.json


echo " Click here to check Dataflow Job is succeeded https://console.cloud.google.com/dataflow/jobs?referrer=search&project=$DEVSHELL_PROJECT_ID"

