

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

# NOTE: Go to Task 1 and Export the variables

```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Ingesting%20FHIR%20Data%20with%20the%20Healthcare%20API/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh

```
## After above command get executed follow the video instructions

```
gcloud healthcare fhir-stores export bq de_id \
--dataset=$DATASET_ID \
--location=$LOCATION \
--bq-dataset=bq://$PROJECT_ID.de_id \
--schema-type=analytics
```

```
SELECT
  id AS patient_id,
  name[safe_offset(0)].given AS given_name,
  name[safe_offset(0)].family AS family,
  birthDate AS birth_date
FROM dataset1.Patient LIMIT 10
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
