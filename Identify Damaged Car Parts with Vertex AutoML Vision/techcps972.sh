

export PROJECT_ID=$DEVSHELL_PROJECT_ID
export BUCKET=$PROJECT_ID

gsutil mb -p $PROJECT_ID \
    -c standard    \
    -l us-central1 \
    gs://${BUCKET}


gsutil -m cp -r gs://car_damage_lab_images/* gs://${BUCKET}

gsutil cp gs://car_damage_lab_metadata/data.csv .

sed -i -e "s/car_damage_lab_images/${BUCKET}/g" ./data.csv

cat ./data.csv

gsutil cp ./data.csv gs://${BUCKET}


wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/main/Identify%20Damaged%20Car%20Parts%20with%20Vertex%20AutoML%20Vision/payload.json

AUTOML_PROXY=$(gcloud run services describe automl-proxy --region=us-central1 --format="value(status.url)")

INPUT_DATA_FILE=payload.json


curl -X POST -H "Content-Type: application/json" $AUTOML_PROXY/v1 -d "@${INPUT_DATA_FILE}"


