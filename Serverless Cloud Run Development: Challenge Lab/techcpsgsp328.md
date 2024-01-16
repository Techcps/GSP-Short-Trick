
# Serverless Cloud Run Development: Challenge Lab [GSP328]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

Click Activate Cloud Shell Activate Cloud Shell icon at the top of the Google Cloud console.

```
gcloud auth list
gcloud config list project
```
```
export PUBLIC_BILLING_SERVICE=
```
```
export FRONTEND_STAGING_SERVICE=
```
```
export PRIVATE_BILLING_SERVICE=
```
```
export BILLING_SERVICE_ACCOUNT=
```
```
export BILLING_PROD_SERVICE=
```
```
export FRONTEND_SERVICE_ACCOUNT=
```
```
export FRONTEND_PRODUCTION_SERVICE=
```

# Task 1. Enable a Public Service

```
cd ~/pet-theory/lab07/unit-api-billing
```
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.1
gcloud run deploy $PUBLIC_BILLING_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.1
```
# Task 2. Deploy a Frontend Service

```
cd ~/pet-theory/lab07/staging-frontend-billing

gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1
gcloud run deploy $FRONTEND_STAGING_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-staging:0.1
```

# Task 3. Deploy a Private Service

```
cd ~/pet-theory/lab07/staging-api-billing
```

```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.2
gcloud run deploy $PRIVATE_BILLING_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/billing-staging-api:0.2
```

# Task 4. Create a Billing Service Account

```
gcloud iam service-accounts create $BILLING_SERVICE_ACCOUNT --display-name "Billing Service Account Cloud Run"
```

# Task 5. Deploy the Billing Service

```
cd ~/pet-theory/lab07/prod-api-billing
```
```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/billing-prod-api:0.1
gcloud run deploy $BILLING_PROD_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/billing-prod-api:0.1
```

# Task 6. Frontend Service Account

```
gcloud iam service-accounts create $FRONTEND_SERVICE_ACCOUNT --display-name "Billing Service Account Cloud Run Invoker"
```

# Task 7. Redeploy the Frontend Service

```
cd ~/pet-theory/lab07/prod-frontend-billing
```

```
gcloud builds submit --tag gcr.io/$DEVSHELL_PROJECT_ID/frontend-prod:0.1
gcloud run deploy $FRONTEND_PRODUCTION_SERVICE --image gcr.io/$DEVSHELL_PROJECT_ID/frontend-prod:0.1
```
## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
