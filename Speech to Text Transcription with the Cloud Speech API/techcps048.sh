

gcloud services enable apikeys.googleapis.com

gcloud alpha services api-keys create --display-name="techcps"

CP=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")

API_KEY=$(gcloud alpha services api-keys get-key-string $CP --format="value(keyString)")



cat > request.json <<EOF_CP
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-samples-data/speech/brooklyn_bridge.flac"
  }
}
EOF_CP

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
cat result.json


cat > request.json <<EOF_CP
 {
  "config": {
      "encoding":"FLAC",
      "languageCode": "fr"
  },
  "audio": {
      "uri":"gs://cloud-samples-data/speech/corbeau_renard.flac"
  }
}
EOF_CP

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
cat result.json

