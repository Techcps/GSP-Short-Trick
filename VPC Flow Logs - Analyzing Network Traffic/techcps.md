
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

# Set ZONE
```
export ZONE=
```

```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/VPC%20Flow%20Logs%20-%20Analyzing%20Network%20Traffic/techcps212.sh
sudo chmod +x techcps212.sh
./techcps212.sh
```

```
CP_IP=$(gcloud compute instances describe web-server --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

export MY_SERVER=$CP_IP

for ((i=1;i<=50;i++)); do curl $MY_SERVER; done
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
