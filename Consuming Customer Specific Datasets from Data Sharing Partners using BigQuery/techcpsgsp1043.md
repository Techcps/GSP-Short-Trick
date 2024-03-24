
# Consuming Customer Specific Datasets from Data Sharing Partners using BigQuery [GSP1043]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

# Task 1 > BigQuery > BigQuery Studio
```
SELECT * FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY state_code ORDER BY area_land_meters DESC) AS cities_by_area
FROM `bigquery-public-data.geo_us_boundaries.zip_codes`) cities
WHERE cities_by_area <= 10 ORDER BY cities.state_code
LIMIT 1000;
```

# Task 2 > BigQuery > BigQuery Studio
```
SELECT *
FROM `qwiklabs-gcp-03-8a8dca00a19b.demo_dataset.authorized_table`
WHERE state_code="NY"
LIMIT 1000
```

## Save > Save View > Dataset Name:
```
data_publisher_dataset
```
Table Name:
```
type authorized_view
```

# Task 3 > BigQuery > BigQuery Studio
```
SELECT cities.zip_code, cities.city, cities.state_code, customers.last_name, customers.first_name
FROM `qwiklabs-gcp-02-0a6a346bea1f.customer_dataset.customer_info` as customers
JOIN `qwiklabs-gcp-03-8d05e2ab3ded.data_publisher_dataset.authorized_view` as cities
ON cities.state_code = customers.state;
```
## Save > Save View > Dataset Name:
```
customer_dataset
```
## Table Name:
```
customer_table
```
## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
