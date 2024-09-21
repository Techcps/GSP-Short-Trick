

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"

export REGION=${ZONE%-*}


gsutil mb -p  $PROJECT_ID gs://$PROJECT_ID

gsutil mb -p  $PROJECT_ID gs://$PROJECT_ID-bqtemp

bq mk -d  loadavro

echo "export REGION=$REGION" > techcps1.sh
echo "export PROJECT_ID=$DEVSHELL_PROJECT_ID" >> techcps1.sh


source techcps1.sh


cat > cp.sh <<'EOF_CP'
source /tmp/techcps1.sh

gcloud config set functions/region $REGION

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

cat > index.js <<EOF
/**
* index.js Cloud Function - Avro on GCS to BQ
*/
const {Storage} = require('@google-cloud/storage');
const {BigQuery} = require('@google-cloud/bigquery');

const storage = new Storage();
const bigquery = new BigQuery();

exports.loadBigQueryFromAvro = async (event, context) => {
    try {
        // Check for valid event data and extract bucket name
        if (!event || !event.bucket) {
            throw new Error('Invalid event data. Missing bucket information.');
        }

        const bucketName = event.bucket;
        const fileName = event.name;

        // BigQuery configuration
        const datasetId = 'loadavro';
        const tableId = fileName.replace('.avro', ''); 

        const options = {
            sourceFormat: 'AVRO',
            autodetect: true, 
            createDisposition: 'CREATE_IF_NEEDED',
            writeDisposition: 'WRITE_TRUNCATE',     
        };

        // Load job configuration
        const loadJob = bigquery
            .dataset(datasetId)
            .table(tableId)
            .load(storage.bucket(bucketName).file(fileName), options);

        await loadJob;
        console.log(`Job ${loadJob.id} completed. Created table ${tableId}.`);

    } catch (error) {
        console.error('Error loading data into BigQuery:', error);
        throw error; 
    }
};

EOF

gsutil mb -p  $PROJECT_ID gs://$PROJECT_ID

bq mk -d  loadavro

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"

npm install @google-cloud/storage @google-cloud/bigquery

sleep 90

gcloud functions deploy loadBigQueryFromAvro \
    --project $PROJECT_ID \
    --runtime nodejs20 \
    --trigger-resource gs://$PROJECT_ID \
    --trigger-event google.storage.object.finalize \
    --no-gen2

wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro

sleep 30

gcloud storage cp campaigns.avro gs://$PROJECT_ID


EOF_CP


gcloud compute scp techcps1.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute scp cp.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh lab-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp.sh"

