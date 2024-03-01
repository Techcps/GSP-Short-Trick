
bq mk fruit_store

bq query --use_legacy_sql=false '
SELECT
["raspberry", "blackberry", "strawberry", "cherry"] AS fruit_array
'
bq query --use_legacy_sql=false '
SELECT person, fruit_array, total_cost FROM `data-to-insights.advanced.fruit_store`;
'

bq query --use_legacy_sql=false \
"
SELECT
  fullVisitorId,
  date,
  v2ProductName,
  pageTitle
  FROM \`data-to-insights.ecommerce.all_sessions\`
WHERE visitId = 1501570398
ORDER BY date
"

bq query --use_legacy_sql=false \
"
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed
  FROM \`data-to-insights.ecommerce.all_sessions\`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date
"

bq query --use_legacy_sql=false \
"
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(v2ProductName)) AS num_products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(pageTitle)) AS num_pages_viewed
  FROM \`data-to-insights.ecommerce.all_sessions\`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date
"

bq query --use_legacy_sql=false \
"
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(DISTINCT v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT v2ProductName)) AS distinct_products_viewed,
  ARRAY_AGG(DISTINCT pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT pageTitle)) AS distinct_pages_viewed
  FROM \`data-to-insights.ecommerce.all_sessions\`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date
"

bq query --use_legacy_sql=false \
"
SELECT
  *
FROM \`bigquery-public-data.google_analytics_sample.ga_sessions_20170801\`
WHERE visitId = 1501570398
"

bq query --use_legacy_sql=false \
"
SELECT DISTINCT
  visitId,
  h.page.pageTitle
FROM \`bigquery-public-data.google_analytics_sample.ga_sessions_20170801\`,
UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10
"

bq query --use_legacy_sql=false \
"
SELECT
  visitId,
  totals.*,
  device.*
FROM \`bigquery-public-data.google_analytics_sample.ga_sessions_20170801\`
WHERE visitId = 1501570398
LIMIT 10
"

bq query --use_legacy_sql=false '
#standardSQL
SELECT STRUCT("Rudisha" as name, 23.4 as split) as runner
'

bq query --use_legacy_sql=false '
#standardSQL
SELECT STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits) AS runner
'

bq mk racing

bq mk --table $DEVSHELL_PROJECT_ID:fruit_store.fruit_details
bq load --source_format=NEWLINE_DELIMITED_JSON --autodetect $DEVSHELL_PROJECT_ID:fruit_store.fruit_details gs://data-insights-course/labs/optimizing-for-performance/shopping_cart.json
cat <<EOF_END > c.json
[
    {
        "name": "race",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "participants",
        "type": "RECORD",
        "mode": "REPEATED",
        "fields": [
            {
                "name": "name",
                "type": "STRING",
                "mode": "NULLABLE"
            },
            {
                "name": "splits",
                "type": "FLOAT",
                "mode": "REPEATED"
            }
        ]
    }
]
EOF_END

bq mk --table --schema=c.json $DEVSHELL_PROJECT_ID:racing.race_results 
bq load --source_format=NEWLINE_DELIMITED_JSON --schema=c.json $DEVSHELL_PROJECT_ID:racing.race_results gs://data-insights-course/labs/optimizing-for-performance/race_results.json

bq query --use_legacy_sql=false '
SELECT * FROM racing.race_results
'

bq query --use_legacy_sql=false '
SELECT race, participants.name
FROM racing.race_results
CROSS JOIN
race_results.participants 
'

bq query --use_legacy_sql=false '
SELECT race, participants.name
FROM racing.race_results AS r, r.participants
'

bq query --use_legacy_sql=false '
SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r, UNNEST(r.participants) AS p
'

bq query --use_legacy_sql=false '
SELECT
  p.name,
  SUM(split_times) as total_race_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_times
WHERE p.name LIKE "R%"
GROUP BY p.name
ORDER BY total_race_time ASC;
'

bq query --use_legacy_sql=false '
#standard
SELECT
  p.name,
  split_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_time
WHERE split_time = 23.2;
'
