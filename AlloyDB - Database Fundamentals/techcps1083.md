
## 💡 Lab Link: [AlloyDB - Database Fundamentals - GSP1083](https://www.cloudskillsboost.google/focuses/100852?parent=catalog)

## 🚀 Lab Solution [Watch Here](https://www.youtube.com/@techcps)

---

## 💡 [Open this link in new tab](https://console.cloud.google.com/alloydb/clusters?referrer=search&project=)


### 💡 Active your Cloud Shell & click (+) icon to launch 2nd Cloud Terminal

1. Export the **REGION** Name correctly in **both Cloud Terminal**
```
export REGION=
```

2. Run the below commands in your **First Cloud Terminal**
```
gcloud beta alloydb clusters create lab-cluster --password=Change3Me --network=peering-network --region=$REGION --project=$DEVSHELL_PROJECT_ID && gcloud beta alloydb instances create lab-instance --project=$DEVSHELL_PROJECT_ID --region=$REGION --cluster=lab-cluster --instance-type=PRIMARY --cpu-count=2
```

3. Run the below commands in your **Second Cloud Terminal**
```
gcloud beta alloydb clusters create gcloud-lab-cluster --password=Change3Me --network=peering-network --region=$REGION --project=$DEVSHELL_PROJECT_ID && gcloud beta alloydb instances create gcloud-lab-instance --project=$DEVSHELL_PROJECT_ID --region=$REGION --cluster=gcloud-lab-cluster --instance-type=PRIMARY --cpu-count=2
```

---

Click (+) icon to launch 3rd Cloud Terminal

1. Export the **ZONE** Name correctly
```
export ZONE=us-east1-c
```

2. Connect **SSH** of **`alloydb-client`**
```
gcloud compute ssh alloydb-client --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet
```

3. **Replacing ALLOYDB_ADDRESS with the Private IP address of the AlloyDB instance**
```
export ALLOYDB=
```

4. Below commands **store the Private IP address of the AlloyDB instance on the AlloyDB client VM**
```
echo $ALLOYDB  > alloydbip.txt 
```

5. This commands launch the **PostgreSQL (psql) client**
```
psql -h $ALLOYDB -U postgres
```

> You will be prompted to provide the postgres user's password **(Change3Me)** which you entered when you created the cluster

6. Input and run the following **SQL commands separately to enable the extension**
```
\c postgres
```

```
CREATE TABLE regions (
    region_id bigint NOT NULL,
    region_name varchar(25)
) ;

ALTER TABLE regions ADD PRIMARY KEY (region_id);
```

```
INSERT INTO regions VALUES ( 1, 'Europe' );

INSERT INTO regions VALUES ( 2, 'Americas' );

INSERT INTO regions VALUES ( 3, 'Asia' );

INSERT INTO regions VALUES ( 4, 'Middle East and Africa' );
```

```
SELECT region_id, region_name from regions;
```

7. Type **\q** to exit the psql client.

8. Run the below command to download a file **containing DDL and DML** for three tables: **countries, departments, and jobs**

```
gsutil cp gs://cloud-training/OCBL403/hrm_load.sql hrm_load.sql
```

9. Reconnect to the PostgreSQL (psql) client
```
psql -h $ALLOYDB -U postgres
```
> You will be prompted to provide the postgres user's password **(Change3Me)**
```
psql -h $ALLOYDB -U postgres
```

```
\i hrm_load.sql
```

```
\dt
```

```
select job_title, max_salary 
from jobs 
order by max_salary desc;
```


### Congratulations, you're all done with the lab 😄

---

### 🌐 Join our Community

- **Join our [Discussion Group](https://t.me/Techcpschat)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)** <img src="https://github.com/user-attachments/assets/6ee41001-c795-467c-8d96-06b56c246b9c" alt="icon" width="25" height="25">
- **Join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)** <img src="https://github.com/user-attachments/assets/aa10b8b2-5424-40bc-8911-7969f29f6dae" alt="icon" width="25" height="25">
- **Join our [Telegram Channel](https://t.me/Techcps)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Follow us on [LinkedIn](https://www.linkedin.com/company/techcps/)** <img src="https://github.com/user-attachments/assets/b9da471b-2f46-4d39-bea9-acdb3b3a23b0" alt="icon" width="25" height="25">

### Thanks for watching :)

