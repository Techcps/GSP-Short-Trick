
gcloud auth list


export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID


gcloud config set compute/region $REGION


gcloud spanner instances create test-instance --project=$DEVSHELL_PROJECT_ID --config=regional-$REGION --description="subscribe to techcps" --nodes=1


gcloud spanner databases create example-db --instance=test-instance

gcloud spanner databases ddl update example-db --instance=test-instance \
  --ddl="CREATE TABLE Singers (
    SingerId INT64 NOT NULL,
    FirstName STRING(1024),
    LastName STRING(1024),
    SingerInfo BYTES(MAX),
    BirthDate DATE,
    ) PRIMARY KEY(SingerId);"

