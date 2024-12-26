

### 💡 Lab Link: [VPC Networks - Controlling Access - GSP213](https://www.cloudskillsboost.google/focuses/1231?parent=catalog)

### 🚀 Lab Solution [Watch Here](https://youtu.be/VxNuS4sQRA8)

---

### ⚠️ Disclaimer
- **This script and guide are provided for  the educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

### ©Credit
- **DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏

---

### 🚨Export the ZONE name correctly:

```
export ZONE=
```

### 🚨Copy and run the below commands in Cloud Shell:

```
export PROJECT_ID=$(gcloud config get-value project)
gcloud compute instances create blue --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --tags=web-server,http-server --create-disk=auto-delete=yes,boot=yes,device-name=blue,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any
gcloud compute instances create green --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=blue,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any
gcloud compute firewall-rules create allow-http-web-server --network=default --action=ALLOW --direction=INGRESS --source-ranges=0.0.0.0/0 --target-tags=web-server --rules=tcp:80,icmp
gcloud compute instances create test-vm --machine-type=e2-micro --subnet=default --zone=$ZONE
```
---
### 🚨NOTE: Go to IAM & admin > Service Accounts > Create service account

> * Service account name to **`Network-admin`** and click CREATE AND CONTINUE
> * Select a role > Compute Engine > Compute Network Admin and click CONTINUE then click DONE
---
```
gcloud iam service-accounts keys create key.json --iam-account=network-admin@$PROJECT_ID.iam.gserviceaccount.com
gcloud compute ssh blue --zone=$ZONE --quiet
```
---
```
sudo apt-get install nginx-light -y
sudo sed -i 's#<h1>Welcome to nginx!</h1>#<h1>Welcome to the blue server!</h1>#' /var/www/html/index.nginx-debian.html
cat /var/www/html/index.nginx-debian.html
exit
```
---
```
gcloud beta compute ssh green --zone=$ZONE --quiet
```
---
```
sudo apt-get install nginx-light -y
sudo sed -i 's#<h1>Welcome to nginx!</h1>#<h1>Welcome to the Green server!</h1>#' /var/www/html/index.nginx-debian.html
cat /var/www/html/index.nginx-debian.html
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
