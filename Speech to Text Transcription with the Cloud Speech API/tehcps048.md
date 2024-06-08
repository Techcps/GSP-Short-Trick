
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

## 🚨 Export ZONE:

```
export ZONE=
```

```
gcloud compute ssh linux-instance --project $DEVSHELL_PROJECT_ID --zone $ZONE --quiet --command "curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Speech%20to%20Text%20Transcription%20with%20the%20Cloud%20Speech%20API/techcps.sh && sudo chmod +x techcps.sh && ./techcps.sh"
```

## 🚨 Check your progress on Task 1-3
## ❌ Do not run the next command until you get the on Task 1-3

```
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
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
