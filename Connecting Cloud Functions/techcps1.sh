

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE
export REGION="${ZONE%-*}"
gcloud config set compute/region $REGION

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')
gcloud config set project $DEVSHELL_PROJECT_ID

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com \
  redis.googleapis.com \
  vpcaccess.googleapis.com


sleep 60


REDIS_INSTANCE=customerdb

gcloud redis instances create $REDIS_INSTANCE \
 --size=2 --region=$REGION \
 --redis-version=redis_6_x
 
gcloud redis instances describe $REDIS_INSTANCE --region=$REGION

REDIS_IP=$(gcloud redis instances describe $REDIS_INSTANCE --region=$REGION --format="value(host)"); echo $REDIS_IP

REDIS_PORT=$(gcloud redis instances describe $REDIS_INSTANCE --region=$REGION --format="value(port)"); echo $REDIS_PORT


gcloud compute networks vpc-access connectors create test-connector --region=$REGION --machine-type=e2-micro --network=default --range=10.8.0.0/28 --max-instances=10 --min-instances=2

gcloud compute networks vpc-access connectors \
  describe test-connector \
  --region $REGION


TOPIC=add_redis

gcloud pubsub topics create $TOPIC


mkdir ~/redis-pubsub && cd $_
touch main.py && touch requirements.txt


cat > main.py <<'EOF_CP'
import os
import base64
import json
import redis
import functions_framework

redis_host = os.environ.get('REDISHOST', 'localhost')
redis_port = int(os.environ.get('REDISPORT', 6379))
redis_client = redis.StrictRedis(host=redis_host, port=redis_port)

# Triggered from a message on a Pub/Sub topic.
@functions_framework.cloud_event
def addToRedis(cloud_event):
    # The Pub/Sub message data is stored as a base64-encoded string in the cloud_event.data property
    # The expected value should be a JSON string.
    json_data_str = base64.b64decode(cloud_event.data["message"]["data"]).decode()
    json_payload = json.loads(json_data_str)
    response_data = ""
    if json_payload and 'id' in json_payload:
        id = json_payload['id']
        data = redis_client.set(id, json_data_str)
        response_data = redis_client.get(id)
        print(f"Added data to Redis: {response_data}")
    else:
        print("Message is invalid, or missing an 'id' attribute")
EOF_CP


cat > requirements.txt <<EOF_CP
functions-framework==3.2.0
redis==4.3.4
EOF_CP


deploy_function() {
    gcloud functions deploy python-pubsub-function \
    --runtime=python310 \
    --region=$REGION \
    --source=. \
    --entry-point=addToRedis \
    --trigger-topic=$TOPIC \
    --vpc-connector projects/$PROJECT_ID/locations/$REGION/connectors/test-connector \
    --set-env-vars REDISHOST=$REDIS_IP,REDISPORT=$REDIS_PORT
}

deploy_success=false

while [ "$deploy_success" = false ]; do
    if deploy_function; then
        echo "Function deployed successfully."
        deploy_success=true
    else
        echo "Retrying in 30 seconds, subscribe to techcps[https://www.youtube.com/@techcps]"
        sleep 30
    fi
done


gcloud pubsub topics publish $TOPIC --message='{"id": 1234, "firstName": "Lucas" ,"lastName": "Sherman", "Phone": "555-555-5555"}'

