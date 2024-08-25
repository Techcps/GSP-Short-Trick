


gcloud auth list

gcloud config set compute/region $REGION

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud spanner instances create banking-instance --project=$DEVSHELL_PROJECT_ID \
--config=regional-$REGION \
--description="subscribe to techcps" \
--nodes=1

gcloud spanner databases create banking-db --instance=banking-instance


gcloud spanner databases ddl update banking-db --instance=banking-instance --ddl="CREATE TABLE Customer (
  CustomerId STRING(36) NOT NULL,
  Name STRING(MAX) NOT NULL,
  Location STRING(MAX) NOT NULL,
) PRIMARY KEY (CustomerId);"


gcloud spanner instances create banking-instance-2 --project=$DEVSHELL_PROJECT_ID \
--config=regional-$REGION \
--description="subscribe to techcps" \
--nodes=2

gcloud spanner databases create banking-db-2 --instance=banking-instance-2


