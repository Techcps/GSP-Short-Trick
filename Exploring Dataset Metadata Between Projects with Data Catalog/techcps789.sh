

echo "Please export the variables carectly"

read -p "Enter BIKE_PROJECT_ID: " BIKE_PROJECT_ID
read -p "Enter MOTOR_PROJECT_ID: " MOTOR_PROJECT_ID
read -p "Enter REGION: " REGION


bq query --use_legacy_sql=false --project_id=$MOTOR_PROJECT_ID \
"
SELECT
  contributing_factor_vehicle_1 AS collision_factor,
  COUNT(*) AS num_collisions
FROM
  \`new_york_mv_collisions.nypd_mv_collisions\`
WHERE
  contributing_factor_vehicle_1 != 'Unspecified'
  AND contributing_factor_vehicle_1 != ''
GROUP BY
  collision_factor
ORDER BY
  num_collisions DESC
LIMIT 10;
"

bq query --use_legacy_sql=false --project_id=$BIKE_PROJECT_ID \
"
WITH unknown AS (
  SELECT
    gender,
    CONCAT(start_station_name, ' to ', end_station_name) AS route,
    COUNT(*) AS num_trips
  FROM
    \`new_york_citibike.citibike_trips\`
  WHERE gender = 'unknown'
  GROUP BY
    gender,
    start_station_name,
    end_station_name
  ORDER BY
    num_trips DESC
  LIMIT 5
)

, female AS (
  SELECT
    gender,
    CONCAT(start_station_name, ' to ', end_station_name) AS route,
    COUNT(*) AS num_trips
  FROM
    \`new_york_citibike.citibike_trips\`
  WHERE gender = 'female'
  GROUP BY
    gender,
    start_station_name,
    end_station_name
  ORDER BY
    num_trips DESC
  LIMIT 5
)

, male AS (
  SELECT
    gender,
    CONCAT(start_station_name, ' to ', end_station_name) AS route,
    COUNT(*) AS num_trips
  FROM
    \`bigquery-public-data.new_york_citibike.citibike_trips\`
  WHERE gender = 'male'
  GROUP BY
    gender,
    start_station_name,
    end_station_name
  ORDER BY
    num_trips DESC
  LIMIT 5
)

SELECT * FROM unknown
UNION ALL
SELECT * FROM female
UNION ALL
SELECT * FROM male;
"


gcloud data-catalog tag-templates create new_york_datasets --project=$BIKE_PROJECT_ID --location=$REGION --display-name="New York Datasets" --field=id=contains_pii,display-name="Contains PII",type='enum(None|Birth date|Gender|Geo location)' --field=id=data_owner_team,display-name="Data Owner Team",type='enum(Marketing|Data Science|Sales|Engineering)',required=TRUE


