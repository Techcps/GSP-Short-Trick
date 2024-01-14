
# Monitoring and Logging for Cloud Functions [GSP092]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
export REGION=
```

```
gcloud auth list
gcloud config list project

cat > index.js <<EOF
exports.helloWorld = (req, res) => {
    res.status(200).send('Hello World!');
};
EOF

gcloud functions deploy helloWorld --runtime nodejs16 --trigger-http --allow-unauthenticated --region $REGION --max-instances 5

gcloud logging metrics create CloudFunctionLatency-Logs --project=$DEVSHELL_PROJECT_ID --description="like share & subscribe to techcps" --log-filter='resource.type="cloud_function"
resource.labels.function_name="helloWorld"'
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
