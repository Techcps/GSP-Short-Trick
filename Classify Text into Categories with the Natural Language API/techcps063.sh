

gcloud services enable language.googleapis.com

sleep 10

cat > request.json <<EOF_CP
{
  "document":{
    "type":"PLAIN_TEXT",
    "content":"A Smoky Lobster Salad With a Tapa Twist. This spin on the Spanish pulpo a la gallega skips the octopus, but keeps the sea salt, olive oil, pimentón and boiled potatoes."
  }
}
EOF_CP

curl "https://language.googleapis.com/v1/documents:classifyText?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @request.json


curl "https://language.googleapis.com/v1/documents:classifyText?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @request.json > result.json

gsutil cat gs://spls/gsp063/bbc_dataset/entertainment/001.txt

bq --location=US mk --dataset news_classification_dataset

bq mk --table news_classification_dataset.article_data article_text:STRING,category:STRING,confidence:FLOAT


