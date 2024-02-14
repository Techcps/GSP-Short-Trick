
bq query --use_legacy_sql=false 'SELECT * FROM `billing_dataset.enterprise_billing` WHERE Cost > 0'

bq query --use_legacy_sql=false \
"
SELECT
 project.name as Project_Name,
 service.description as Service,
 location.country as Country,
 cost as Cost
FROM \`billing_dataset.enterprise_billing\`;
"

bq query --use_legacy_sql=false 'SELECT CONCAT(service.description, " : ", sku.description) as Line_Item FROM `billing_dataset.enterprise_billing` GROUP BY 1'

bq query --use_legacy_sql=false 'SELECT CONCAT(service.description, " : ", sku.description) as Line_Item, COUNT(*) as NUM FROM `billing_dataset.enterprise_billing` GROUP BY CONCAT(service.description, " : ", sku.description)'


bq query --use_legacy_sql=false 'SELECT project.id, COUNT(*) as count FROM `billing_dataset.enterprise_billing` GROUP BY project.id'

