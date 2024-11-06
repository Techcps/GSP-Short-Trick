
gcloud auth list

gcloud alpha services api-keys create --display-name="techcps"

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")

API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

gsutil mb gs://$PROJECT_ID

curl -O https://github.com/Techcps/GSP-Short-Trick/blob/main/Extract%2C%20Analyze%2C%20and%20Translate%20Text%20from%20Images%20with%20the%20Cloud%20ML%20APIs/sign.jpg

gsutil cp sign.jpg gs://$PROJECT_ID/sign.jpg

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/sign.jpg

touch ocr-request.json
tee ocr-request.json <<EOF_CP
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "gs://$PROJECT_ID/sign.jpg"
          }
        },
        "features": [
          {
            "type": "TEXT_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF_CP

curl -s -X POST -H "Content-Type: application/json" --data-binary @ocr-request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}

curl -s -X POST -H "Content-Type: application/json" --data-binary @ocr-request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY} -o ocr-response.json

touch translation-request.json

tee translation-request.json <<EOF_CP
{
  "q": "subscribe to techcps", 
  "target": "en"
}
EOF_CP

STR=$(jq .responses[0].textAnnotations[0].description ocr-response.json) && STR="${STR//\"}" && sed -i "s|your_text_here|$STR|g" translation-request.json
curl -s -X POST -H "Content-Type: application/json" --data-binary @translation-request.json https://translation.googleapis.com/language/translate/v2?key=${API_KEY} -o translation-response.json

cat translation-response.json

touch nl-request.json.json
tee nl-request.json <<EOF_CP
{
  "document":{
    "type":"PLAIN_TEXT",
    "content":"like share & subscribe to techcps"
  },
  "encodingType":"UTF8"
}
EOF_CP

STR=$(jq .data.translations[0].translatedText  translation-response.json) && STR="${STR//\"}" && sed -i "s|your_text_here|$STR|g" nl-request.json
curl "https://language.googleapis.com/v1/documents:analyzeEntities?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @nl-request.json
