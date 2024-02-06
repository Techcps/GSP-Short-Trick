
# Working with Virtual Machines

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)


* In the GCP Console active your Cloud Shell and run the following commands:


```
export ZONE=
```
```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Working%20with%20Virtual%20Machines/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```
## Initialize the Minecraft server

```
sudo ls -l

sudo nano eula.txt
```
## Change the last line of the file from eula=false to eula=true.
## Press Ctrl+X and Y ENTER to save the file and exit the nono editer

## Create a backup script

```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Working%20with%20Virtual%20Machines/buckets.sh
sudo chmod +x buckets.sh
./buckets.sh

```

```
sudo nano /home/minecraft/backup.sh
```
```
#!/bin/bash
screen -r mcs -X stuff '/save-all\n/save-off\n'
/usr/bin/gcloud storage cp -R ${BASH_SOURCE%/*}/world gs://${DEVSHELL_PROJECT_ID}-minecraft-backup/$(date "+%Y%m%d-%H%M%S")-world
screen -r mcs -X stuff '/save-on\n'
```

## Press Ctrl+X and Y ENTER to save the file and exit the nono editer

```
sudo chmod 755 /home/minecraft/backup.sh
. /home/minecraft/backup.sh
```

```
sudo crontab -e
```
## At the bottom of the cron table, paste the following line:
```
0 */4 * * * /home/minecraft/backup.sh
```
## Press Ctrl+X and Y ENTER to save the file and exit the nono editer

```
sudo screen -r -X stuff '/stop\n'
exit
```
```
gcloud compute instances add-metadata mc-server --zone=$ZONE --metadata project-id=$PROJECT_ID,startup-script-url=https://storage.googleapis.com/cloud-training/archinfra/mcserver/startup.sh,shutdown-script-url=https://storage.googleapis.com/cloud-training/archinfra/mcserver/shutdown.sh
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
