
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
## Prepare the data disk

```
gcloud compute ssh mc-server --zone=$ZONE --quiet
```
```
sudo mkdir -p /home/minecraft
sudo mkfs.ext4 -F -E lazy_itable_init=0,\
lazy_journal_init=0,discard \
/dev/disk/by-id/google-minecraft-disk
sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft
sudo apt-get update
sudo apt-get install -y default-jre-headless
cd /home/minecraft
sudo apt-get install wget -y
sudo wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar
sudo java -Xmx1024M -Xms1024M -jar server.jar nogui
```

## Initialize the Minecraft server

```
sudo ls -l
```
```

sudo nano eula.txt
```
## Change the last line of the file from eula=false to eula=true.
## Press Ctrl+X and Y ENTER to save the file and exit the nono editer

## Create a backup script

```
sudo apt-get install -y screen
sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui
```
## To detach the screen terminal, press Ctrl+A, Ctrl+D
```
export PROJECT_ID=$(gcloud config get-value project)
export BUCKET_NAME=$PROJECT_ID
echo $PROJECT_ID && gcloud storage buckets create gs://$PROJECT_ID-minecraft-backup
# echo BUCKET_NAME=$PROJECT_ID >> ~/.profile"
cd /home/minecraft
```

```
sudo nano /home/minecraft/backup.sh
```
```
#!/bin/bash
screen -r mcs -X stuff '/save-all\n/save-off\n'
/usr/bin/gcloud storage cp -R ${BASH_SOURCE%/*}/world gs://${PROJECT_ID}-minecraft-backup/$(date "+%Y%m%d-%H%M%S")-world
screen -r mcs -X stuff '/save-on\n'
```

## Press Ctrl+X and Y ENTER to save the file and exit the nono editer

```
sudo chmod 755 /home/minecraft/backup.sh
```
```
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
