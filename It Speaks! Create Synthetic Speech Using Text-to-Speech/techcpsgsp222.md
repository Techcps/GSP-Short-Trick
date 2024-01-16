
# It Speaks! Create Synthetic Speech Using Text-to-Speech [GSP222]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)
gcloud services enable texttospeech.googleapis.com
sudo apt-get install -y virtualenv
python3 -m venv venv
source venv/bin/activate
gcloud iam service-accounts create tts-qwiklab
gcloud iam service-accounts keys create tts-qwiklab.json --iam-account tts-qwiklab@$PROJECT_ID.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS=tts-qwiklab.json
```

## Congratulations, you're all done with the lab 😄
# Thanks for watching :)
