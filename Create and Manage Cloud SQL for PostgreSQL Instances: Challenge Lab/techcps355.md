
### 💡 Lab Link: [Create and Manage Cloud SQL for PostgreSQL Instances: Challenge Lab - GSP355](https://www.cloudskillsboost.google/focuses/23465?parent=catalog)

### 🚀 Lab Solution [Watch Here](https://www.youtube.com/@techcps)

---

### ⚠️ Disclaimer
- **This script and guide are provided for  the educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**
 
---

### Enable the following Google APIs:

- **[Database Migration API](https://console.cloud.google.com/marketplace/product/google/datamigration.googleapis.com?q=search&referrer=search&project=)**

- **[Service Networking API](https://console.cloud.google.com/marketplace/product/google/servicenetworking.googleapis.com?q=search&referrer=search&project=)**
---

### Compute Engine > VM instances > Connect the SSH of postgresql-vm

- **install the pglogical database extension and jquery**
```
sudo apt install postgresql-13-pglogical
```

- **Download and apply some additions to the PostgreSQL configuration files (to enable pglogical extension)**
```
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/pg_hba_append.conf ."
sudo su - postgres -c "gsutil cp gs://cloud-training/gsp918/postgresql_append.conf ."
sudo su - postgres -c "cat pg_hba_append.conf >> /etc/postgresql/13/main/pg_hba.conf"
sudo su - postgres -c "cat postgresql_append.conf >> /etc/postgresql/13/main/postgresql.conf"
sudo systemctl restart postgresql@13-main
```

- **Apply required privileges to postgres and orders databases**

```
sudo su - postgres
```

```
psql
```

```
\c postgres;
```

```
CREATE EXTENSION pglogical;
```

```
\c orders;
```

```
CREATE EXTENSION pglogical;
```
---

### Open the below website

- **[Online word replacer](https://www.unit-conversion.info/texttools/replace-text/)**

- **[Online Notepad](https://www.rapidtables.com/tools/notepad.html)**


```
CREATE USER migration_admin PASSWORD 'DMS_1s_cool!';
ALTER DATABASE orders OWNER TO migration_admin;
ALTER ROLE migration_admin WITH REPLICATION;


\c orders;


SELECT column_name FROM information_schema.columns WHERE table_name = 'inventory_items' AND column_name = 'id';
ALTER TABLE inventory_items ADD PRIMARY KEY (id);


GRANT USAGE ON SCHEMA pglogical TO migration_admin;
GRANT ALL ON SCHEMA pglogical TO migration_admin;
GRANT SELECT ON pglogical.tables TO migration_admin;
GRANT SELECT ON pglogical.depend TO migration_admin;
GRANT SELECT ON pglogical.local_node TO migration_admin;
GRANT SELECT ON pglogical.local_sync_status TO migration_admin;
GRANT SELECT ON pglogical.node TO migration_admin;
GRANT SELECT ON pglogical.node_interface TO migration_admin;
GRANT SELECT ON pglogical.queue TO migration_admin;
GRANT SELECT ON pglogical.replication_set TO migration_admin;
GRANT SELECT ON pglogical.replication_set_seq TO migration_admin;
GRANT SELECT ON pglogical.replication_set_table TO migration_admin;
GRANT SELECT ON pglogical.sequence_state TO migration_admin;
GRANT SELECT ON pglogical.subscription TO migration_admin;



GRANT USAGE ON SCHEMA public TO migration_admin;
GRANT ALL ON SCHEMA public TO migration_admin;
GRANT SELECT ON public.distribution_centers TO migration_admin;
GRANT SELECT ON public.inventory_items TO migration_admin;
GRANT SELECT ON public.order_items TO migration_admin;
GRANT SELECT ON public.products TO migration_admin;
GRANT SELECT ON public.users TO migration_admin;



ALTER TABLE public.distribution_centers OWNER TO migration_admin;
ALTER TABLE public.inventory_items OWNER TO migration_admin;
ALTER TABLE public.order_items OWNER TO migration_admin;
ALTER TABLE public.products OWNER TO migration_admin;
ALTER TABLE public.users OWNER TO migration_admin;



\c postgres;


GRANT USAGE ON SCHEMA pglogical TO migration_admin;
GRANT ALL ON SCHEMA pglogical TO migration_admin;
GRANT SELECT ON pglogical.tables TO migration_admin;
GRANT SELECT ON pglogical.depend TO migration_admin;
GRANT SELECT ON pglogical.local_node TO migration_admin;
GRANT SELECT ON pglogical.local_sync_status TO migration_admin;
GRANT SELECT ON pglogical.node TO migration_admin;
GRANT SELECT ON pglogical.node_interface TO migration_admin;
GRANT SELECT ON pglogical.queue TO migration_admin;
GRANT SELECT ON pglogical.replication_set TO migration_admin;
GRANT SELECT ON pglogical.replication_set_seq TO migration_admin;
GRANT SELECT ON pglogical.replication_set_table TO migration_admin;
GRANT SELECT ON pglogical.sequence_state TO migration_admin;
GRANT SELECT ON pglogical.subscription TO migration_admin;
```

---

### Task 3. Implement Cloud SQL for PostgreSQL IAM database authentication

- **Asking For a password enter**

```
supersecret!
```
> Copy and paste the password and the password will not visible to you

```
\c orders
```

- **Asking For a password enter**
```
supersecret!
```
> Copy and paste the password and the password will not visible to you

---

- ⚠️ **Change the TABLE_NAME and USER_NAME by given lab instructions**
```
GRANT ALL PRIVILEGES ON TABLE [TABLE_NAME] TO "USER_NAME";

\q
```

---

### Task 4. Configure and test point-in-time recovery

```
date --rfc-3339=seconds
```
> Copy the given output and Save this

- **Asking For a password enter**
```
supersecret!
```
> Copy and paste the password and the password will not visible to you


```
\c orders
```

- **Asking For a password enter**
```
supersecret!
```
> Copy and paste the password and the password will not visible to you

```
insert into distribution_centers values(-80.1918,25.7617,'Miami FL',11);
\q
```

```
gcloud auth login --quiet

gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID
```


```
export INSTANCE_ID=
```

```
gcloud sql instances clone $INSTANCE_ID  postgres-orders-pitr --point-in-time 'CHANGE_TIMESTAMP'
```

---

### Congratulations, you're all done with the lab 😄

---

### 🌐 Join our Community

- <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25"> **Join our [Telegram Channel](https://t.me/Techcps) for the latest updates & [Discussion Group](https://t.me/Techcpschat) for the lab enquiry**
- <img src="https://github.com/user-attachments/assets/aa10b8b2-5424-40bc-8911-7969f29f6dae" alt="icon" width="25" height="25"> **Join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A) for the latest updates**
- <img src="https://github.com/user-attachments/assets/b9da471b-2f46-4d39-bea9-acdb3b3a23b0" alt="icon" width="25" height="25"> **Follow us on [LinkedIn](https://www.linkedin.com/company/techcps/) for updates and opportunities.**
- <img src="https://github.com/user-attachments/assets/a045f610-775d-432a-b171-97a2d19718e2" alt="icon" width="25" height="25"> **Follow us on [TwitterX](https://twitter.com/Techcps_/) for the latest updates**
- <img src="https://github.com/user-attachments/assets/84e23456-7ed3-402a-a8a9-5d2fb5b44849" alt="icon" width="25" height="25"> **Follow us on [Instagram](https://instagram.com/techcps/) for the latest updates**
- <img src="https://github.com/user-attachments/assets/fc77ddc4-5b3b-42a9-a8da-e5561dce0c70" alt="icon" width="25" height="25"> **Follow us on [Facebook](https://facebook.com/techcps/) for the latest updates**

---

# <img src="https://github.com/user-attachments/assets/6ee41001-c795-467c-8d96-06b56c246b9c" alt="icon" width="45" height="45"> [Techcps](https://www.youtube.com/@techcps) Don't Forget to like share & subscribe

### Thanks for watching and stay connected :)
---
