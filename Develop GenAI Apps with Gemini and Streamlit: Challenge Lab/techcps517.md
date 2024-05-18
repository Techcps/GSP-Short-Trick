
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

## [First open in the new tab and download the file](https://github.com/Techcps/GSP/blob/main/Develop%20GenAI%20Apps%20with%20Gemini%20and%20Streamlit%3A%20Challenge%20Lab/prompt.ipynb)
```
export REGION=
```

```

gcloud services enable run.googleapis.com --project $DEVSHELL_PROJECT_ID

git clone https://github.com/GoogleCloudPlatform/generative-ai.git

cd generative-ai/gemini/sample-apps/gemini-streamlit-cloudrun

gsutil cp gs://spls/gsp517/chef.py .

rm -rf Dockerfile chef.py

wget https://raw.githubusercontent.com/Techcps/GSP/master/Develop%20GenAI%20Apps%20with%20Gemini%20and%20Streamlit%3A%20Challenge%20Lab/Dockerfile.txt

wget https://raw.githubusercontent.com/Techcps/GSP/master/Develop%20GenAI%20Apps%20with%20Gemini%20and%20Streamlit%3A%20Challenge%20Lab/chef.py

mv Dockerfile.txt Dockerfile

gcloud storage cp chef.py gs://$DEVSHELL_PROJECT_ID-generative-ai/

# Set the python virtual environment and install the dependencies
python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate
python3 -m  pip install -r requirements.txt


# Set environment variables for project id
export PROJECT=$DEVSHELL_PROJECT_ID


# Run the chef.py application
streamlit run chef.py \
  --browser.serverAddress=localhost \
  --server.enableCORS=false \
  --server.enableXsrfProtection=false \
  --server.port 8080
```

## Click on the link & Test the app from video instructions

## Press Ctrl+c for terminate the script.

```
AR_REPO='chef-repo'
SERVICE_NAME='chef-streamlit-app'

gcloud artifacts repositories create "$AR_REPO" --repository-format=Docker --location="$REGION"
sleep 10
gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT/$AR_REPO/$SERVICE_NAME"


gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$PROJECT \
  --set-env-vars=GCP_PROJECT=$PROJECT,GCP_REGION=$REGION
```

## Click on the link & Test the app from video instructions

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
