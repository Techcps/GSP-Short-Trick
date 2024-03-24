
cat > view.py <<EOF_CP
from google.cloud import bigquery
client = bigquery.Client()
source_dataset_id = "data_publisher_dataset"
source_dataset_id_full = "{}.{}".format(client.project, source_dataset_id)
source_dataset = bigquery.Dataset(source_dataset_id_full)
view_id_a = "$DEVSHELL_PROJECT_ID.data_publisher_dataset.authorized_view"
view_a = bigquery.Table(view_id_a)
view_a.view_query = f"SELECT * FROM \`$SHARED_ID.demo_dataset.authorized_table\` WHERE state_code='NY' LIMIT 1000"
view_a = client.create_table(view_a)
access_entries = source_dataset.access_entries
access_entries.append(
bigquery.AccessEntry(None, "view", view_a.reference.to_api_repr())
)
source_dataset.access_entries = access_entries
source_dataset = client.update_dataset(
source_dataset, ["access_entries"]
)

print(f"Created {view_a.table_type}: {str(view_a.reference)}")
EOF_CP

python3 view.py

sleep 3

echo "PUBLISHER ID : $DEVSHELL_PROJECT_ID"
