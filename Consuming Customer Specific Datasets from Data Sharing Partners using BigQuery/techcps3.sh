
cat > view_b.py <<EOF_CP
from google.cloud import bigquery
client = bigquery.Client()
view_id = "$DEVSHELL_PROJECT_ID.customer_dataset.customer_table"
view = bigquery.Table(view_id)
view.view_query = f"SELECT cities.zip_code, cities.city, cities.state_code, customers.last_name, customers.first_name FROM \`$DEVSHELL_PROJECT_ID.customer_dataset.customer_info\` as customers JOIN \`$PUBLISHER_ID.data_publisher_dataset.authorized_view\` as cities ON cities.state_code = customers.state;"
view = client.create_table(view)

print(f"Created {view.table_type}: {str(view.reference)}")
EOF_CP

python3 view_b.py
