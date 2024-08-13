
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)


## 🚨Copy and run the below commands in Cloud Shell:

```
gcloud services enable artifactregistry.googleapis.com cloudfunctions.googleapis.com cloudbuild.googleapis.com eventarc.googleapis.com run.googleapis.com logging.googleapis.com storage.googleapis.com pubsub.googleapis.com
```

### 🚨 Set up Firestore

- Click **Create Database**

- Click **Native mode** (recommended), and then click **Continue**

- Choose **Region** from lab instructions

- For **Secure rules**, select **Test rules**

- Click **Create Database**

### 🚨 Click Start collection

- For **Collection ID** type **customers**

- Click **Document ID**: **`Genarate Automatically`**

### 🚨 **Add Fields** with the following values:


|       Field name       |       Field type	       |       Field value       |
| ---------------------- | ----------------------- | ----------------------- |
|       firstname        |         string 	       |          Lucas          |


- Click the **Add a Field (+)** button to add Second field:


|       Field name       |       Field type	       |       Field value       |
| ---------------------- | ----------------------- | ----------------------- |
|        lastname        |         string 	       |         Sherman         |


### 🚨 **Click Save**

## 🚨Export the variables name correctly:
```
export REGION=
```

## 🚨Copy and run the below commands in Cloud Shell:
```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Integrating%20Cloud%20Functions%20with%20Firestore/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```

### 🚨 Now Delete the old Second field and again create with the following values:


|       Field name       |       Field type	       |       Field value       |
| ---------------------- | ----------------------- | ----------------------- |
|        lastname        |         string 	       |         Sherman         |


## Congratulations, you're all done with the lab 😄

# Thanks for watching :)

