

gcloud services enable apikeys.googleapis.com

gcloud alpha services api-keys create --display-name="techcps"

CP=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")

API_KEY=$(gcloud alpha services api-keys get-key-string $CP --format="value(keyString)")


cat > request.json <<EOF_CP
{
  "document":{
    "type":"PLAIN_TEXT",
    "content":"Joanne Rowling, who writes under the pen names J. K. Rowling and Robert Galbraith, is a British novelist and screenwriter who wrote the Harry Potter fantasy series."
  },
  "encodingType":"UTF8"
}
EOF_CP

curl "https://language.googleapis.com/v1/documents:analyzeEntities?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @request.json > result.json


