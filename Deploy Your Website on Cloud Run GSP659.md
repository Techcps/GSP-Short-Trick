
# Deploy Your Website on Cloud Run [GSP659]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)


```
export REGION=
```

```
gcloud auth list
gcloud config list project
git clone https://github.com/googlecodelabs/monolith-to-microservices.git
cd ~/monolith-to-microservices./setup.sh
./setup.sh
cd ~/monolith-to-microservices/monolith
npm start
gcloud artifacts repositories create monolith-demo --location=$REGION --repository-format=docker
gcloud auth configure-docker $REGION-docker.pkg.dev
gcloud services enable artifactregistry.googleapis.com \
    cloudbuild.googleapis.com \
    run.googleapis.com
gcloud builds submit --tag $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0
gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0 --allow-unauthenticated --region $REGION
gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0 --allow-unauthenticated --region $REGION --concurrency 1
gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0 --allow-unauthenticated --region $REGION --concurrency 80
cd ~/monolith-to-microservices/react-app/src/pages/Home
mv index.js.new index.js
cd ~/monolith-to-microservices/react-app
npm run build:monolith
cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:2.0.0
gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:2.0.0 --allow-unauthenticated --region $REGION
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
