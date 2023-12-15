
#  Using BigQuery in the Google Cloud Console [GSP406]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
bq query --use_legacy_sql=false \
"
SELECT
name, gender,
SUM(number) AS total
FROM
\`bigquery-public-data.usa_names.usa_1910_2013\`
GROUP BY
name, gender
ORDER BY
total DESC
LIMIT
10
"
bq mk babynames
bq mk --table \
--schema "name:string,count:integer,gender:string" \
$DEVSHELL_PROJECT_ID:babynames.names_2014

bq query --use_legacy_sql=false \
"
SELECT
name, count
FROM
\`babynames.names_2014\`
WHERE
gender = 'M'
ORDER BY count DESC LIMIT 5
"
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
