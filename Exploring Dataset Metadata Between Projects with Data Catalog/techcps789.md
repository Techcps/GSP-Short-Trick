


# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

# Make sure login with Global owner user id

## Motor vehicle collision project id

```
bq query --use_legacy_sql=false "
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
```

## Bike Share dataset project id

```
bq query --use_legacy_sql=false "
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
),

female AS (
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
),

male AS (
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
```

## Task 6: Follow the lab & video instructions

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)

