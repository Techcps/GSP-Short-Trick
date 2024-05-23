
gcloud bigtable backups create current_conditions_30 --project=$DEVSHELL_PROJECT_ID --instance=sandiego --cluster=sandiego-traffic-sensors-c1 --retention-period=30d --table=current_conditions


gcloud bigtable instances tables restore --project=$DEVSHELL_PROJECT_ID --source=projects/$DEVSHELL_PROJECT_ID/instances/sandiego/clusters/sandiego-traffic-sensors-c1/backups/current_conditions_30 --async --destination=current_conditions_30_restored --destination-instance=sandiego

