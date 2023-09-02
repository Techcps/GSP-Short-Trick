
# Google Cloud Speech API: Qwik Start [GSP119]
In the Navigation menu, select Compute Engine. Click on the SSH button in line with the linux-instance. You will be brought to an interactive shell.



```
export API_KEY=
```

```
cat > request.json <<EOF
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-samples-tests/speech/brooklyn.flac"
  }
}
EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}"

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json

```

## Congratulations, you're all done with the lab 😄 Don't forget to subscribe my YouTube Channel😄

##  Thanks for watching.!



