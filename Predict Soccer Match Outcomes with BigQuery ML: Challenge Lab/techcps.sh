


export PROJECT_ID="$(gcloud config get-value project)"

bq load --autodetect --source_format=NEWLINE_DELIMITED_JSON $PROJECT_ID:soccer.$EVENT_NAME gs://spls/bq-soccer-analytics/events.json

bq load --autodetect --source_format=CSV $PROJECT_ID:soccer.$TABLE_NAME gs://spls/bq-soccer-analytics/tags2name.csv


bq query --use_legacy_sql=false \
"
SELECT
playerId,
(Players.firstName || ' ' || Players.lastName) AS playerName,
COUNT(id) AS numPKAtt,
SUM(IF(101 IN UNNEST(tags.id), 1, 0)) AS numPKGoals,
SAFE_DIVIDE(
SUM(IF(101 IN UNNEST(tags.id), 1, 0)),
COUNT(id)
) AS PKSuccessRate
FROM
\`soccer.$EVENT_NAME\` Events
LEFT JOIN
\`soccer.players\` Players ON
Events.playerId = Players.wyId
WHERE
eventName = 'Free Kick' AND
subEventName = 'Penalty'
GROUP BY
playerId, playerName
HAVING
numPkAtt >= 5
ORDER BY
PKSuccessRate DESC, numPKAtt DESC
"


bq query --use_legacy_sql=false \
"
WITH
Shots AS
(
SELECT
*,
/* 101 is known Tag for 'goals' from goals table */
(101 IN UNNEST(tags.id)) AS isGoal,
/* Translate 0-100 (x,y) coordinate-based distances to absolute positions
using "average" field dimensions of 105x68 before combining in 2D dist calc */
SQRT(
POW(
  (100 - positions[ORDINAL(1)].x) * $CP_VALUE_X1/$CP_VALUE_Y1,
  2) +
POW(
  (60 - positions[ORDINAL(1)].y) * $CP_VALUE_X2/$CP_VALUE_Y2,
  2)
 ) AS shotDistance
FROM
\`soccer.$EVENT_NAME\`
WHERE
/* Includes both "open play" & free kick shots (including penalties) */
eventName = 'Shot' OR
(eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
)
SELECT
ROUND(shotDistance, 0) AS ShotDistRound0,
COUNT(*) AS numShots,
SUM(IF(isGoal, 1, 0)) AS numGoals,
AVG(IF(isGoal, 1, 0)) AS goalPct
FROM
Shots
WHERE
shotDistance <= 50
GROUP BY
ShotDistRound0
ORDER BY
ShotDistRound0
"


bq query --use_legacy_sql=false \
"
CREATE FUNCTION \`$FUNCTION_NAME\`(x INT64, y INT64)
RETURNS FLOAT64
AS (
 /* Translate 0-100 (x,y) coordinate-based distances to absolute positions
 using "average" field dimensions of $CP_VALUE_X2x$CP_VALUE_Y2 before combining in 2D dist calc */
 SQRT(
   POW(($CP_VALUE_X1 - x) * $CP_VALUE_X2/100, 2) +
   POW(($CP_VALUE_Y1 - y) * $CP_VALUE_Y2/100, 2)
   )
 );
"


bq query --use_legacy_sql=false '
CREATE FUNCTION `$FUNCTION_NAME_2`(x INT64, y INT64)
RETURNS FLOAT64
LANGUAGE js AS """
var CP_VALUE_X2 = parseFloat('$CP_VALUE_X2');
var CP_VALUE_Y2 = parseFloat('$CP_VALUE_Y2');
var CP_VALUE = parseFloat('$CP_VALUE');

// Have to translate 0-100 (x,y) coordinates to absolute positions using
// "average" field dimensions of $CP_VALUE_X2x$CP_VALUE_Y2 before using in various distance calcs
var d1 = Math.sqrt(Math.pow((CP_VALUE_X2 - (x * CP_VALUE_X2/100)), 2) + Math.pow((CP_VALUE + (7.32/2) - (y * CP_VALUE_Y2/100)), 2));
var d2 = Math.sqrt(Math.pow((CP_VALUE_X2 - (x * CP_VALUE_X2/100)), 2) + Math.pow((CP_VALUE - (7.32/2) - (y * CP_VALUE_Y2/100)), 2));
var d3 = Math.sqrt(Math.pow(CP_VALUE_X2 - (x * CP_VALUE_X2/100), 2) + Math.pow(CP_VALUE + 7.32/2 - (y * CP_VALUE_Y2/100), 2));
var d4 = Math.sqrt(Math.pow(CP_VALUE_X2 - (x * CP_VALUE_X2/100), 2) + Math.pow(CP_VALUE - 7.32/2 - (y * CP_VALUE_Y2/100), 2));

// Calculate angle
var angle = Math.acos((Math.pow(d1, 2) + Math.pow(d2, 2) - Math.pow(7.32, 2)) / (2 * d1 * d2));

// Translate radians to degrees
var angleDegrees = angle * (180 / Math.PI);

return angleDegrees;
""";
'


bq query --use_legacy_sql=false '
CREATE MODEL `'$MODEL_NAME'`
OPTIONS(
model_type = "LOGISTIC_REG",
input_label_cols = ["isGoal"]
) AS
SELECT
Events.subEventName AS shotType,
(101 IN UNNEST(Events.tags.id)) AS isGoal,
`'$FUNCTION_NAME_1'` (Events.positions[ORDINAL(1)].x,
Events.positions[ORDINAL(1)].y) AS shotDistance,
`'$FUNCTION_NAME_2'` (Events.positions[ORDINAL(1)].x,
Events.positions[ORDINAL(1)].y) AS shotAngle
FROM
`soccer.'$EVENT_NAME'` Events
LEFT JOIN
`soccer.matches` Matches ON
Events.matchId = Matches.wyId
LEFT JOIN
`soccer.competitions` Competitions ON
Matches.competitionId = Competitions.wyId
WHERE
Competitions.name != "World Cup" AND
(
eventName = "Shot" OR
(eventName = "Free Kick" AND subEventName IN ("Free kick shot", "Penalty"))
)
;'



bq query --use_legacy_sql=false '
SELECT
predicted_isGoal_probs[ORDINAL(1)].prob AS predictedGoalProb,
* EXCEPT (predicted_isGoal, predicted_isGoal_probs),
FROM
ML.PREDICT(
MODEL `'$MODEL_NAME'`, 
(
 SELECT
   Events.playerId,
   (Players.firstName || " " || Players.lastName) AS playerName,
   Teams.name AS teamName,
   CAST(Matches.dateutc AS DATE) AS matchDate,
   Matches.label AS match,
 /* Convert match period and event seconds to minute of match */
   CAST((CASE
     WHEN Events.matchPeriod = "1H" THEN 0
     WHEN Events.matchPeriod = "2H" THEN 45
     WHEN Events.matchPeriod = "E1" THEN 90
     WHEN Events.matchPeriod = "E2" THEN 105
     ELSE 120
     END) +
     CEILING(Events.eventSec / 60) AS INT64)
     AS matchMinute,
   Events.subEventName AS shotType,

   (101 IN UNNEST(Events.tags.id)) AS isGoal,
 
   `'$FUNCTION_NAME_1'`(Events.positions[ORDINAL(1)].x,
       Events.positions[ORDINAL(1)].y) AS shotDistance,
   `'$FUNCTION_NAME_2'`(Events.positions[ORDINAL(1)].x,
       Events.positions[ORDINAL(1)].y) AS shotAngle
 FROM
   `soccer.'$EVENT_NAME'` Events
 LEFT JOIN
   `soccer.matches` Matches ON
       Events.matchId = Matches.wyId
 LEFT JOIN
   `soccer.competitions` Competitions ON
       Matches.competitionId = Competitions.wyId
 LEFT JOIN
   `soccer.players` Players ON
       Events.playerId = Players.wyId
 LEFT JOIN
   `soccer.teams` Teams ON
       Events.teamId = Teams.wyId
 WHERE
   /* Look only at World Cup matches to apply model */
   Competitions.name = "World Cup" AND

   (
     eventName = "Shot" OR
     (eventName = "Free Kick" AND subEventName IN ("Free kick shot"))
   ) AND
   /* Filter only to goals scored */
   (101 IN UNNEST(Events.tags.id))
)
)
ORDER BY
predictedgoalProb'


