
gcloud auth list

gcloud config set project $(gcloud projects list --format='value(PROJECT_ID)' --filter='qwiklabs-gcp')

gcloud firestore databases create --location=$REGION --project=$DEVSHELL_PROJECT_ID

sleep 17

gcloud services enable run.googleapis.com

git clone https://github.com/rosera/pet-theory.git

cd pet-theory/lab06/firebase-import-csv/solution

npm install
node index.js netflix_titles_original.csv

cd ~/pet-theory/lab06/firebase-rest-api/solution-01
npm install
cd ~/pet-theory/lab06/firebase-rest-api/solution-01

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/rest-api:0.1 .

gcloud run deploy $DATASET_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/rest-api:0.1 --allow-unauthenticated --max-instances=1 --region=$REGION 

SERVICE_URL=$(gcloud run services describe $DATASET_SERVICE --region=$REGION --format 'value(status.url)')

curl -X GET $SERVICE_URL

cd ~/pet-theory/lab06/firebase-rest-api/solution-02
npm install
cd ~/pet-theory/lab06/firebase-rest-api/solution-02

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/rest-api:0.2 .

gcloud run deploy $DATASET_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/rest-api:0.2 --region=$REGION --allow-unauthenticated --max-instances=1

SERVICE_URL=$(gcloud run services describe $DATASET_SERVICE --region=$REGION --format 'value(status.url)')

curl -X GET $SERVICE_URL/2019

npm install && npm run build

cd ~/pet-theory/lab06/firebase-frontend

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1 .

gcloud run deploy $FRONTEND_STAGING_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1 --platform managed --region=$REGION --max-instances 1 --allow-unauthenticated --quiet

gcloud run services describe $FRONTEND_STAGING_SERVICE --region=$REGION --format="value(status.url)"

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-production:0.1
gcloud run deploy $FRONTEND_PRODUCTION_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-production:0.1 --platform managed --region=$REGION --max-instances=1 --quiet
