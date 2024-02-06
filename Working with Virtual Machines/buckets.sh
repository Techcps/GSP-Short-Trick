
sudo apt-get install -y screen

sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui

export PROJECT_ID=$(gcloud config get-value project)

export BUCKET_NAME=$DEVSHELL_PROJECT_ID

echo $DEVSHELL_PROJECT_ID && gcloud storage buckets create gs://$DEVSHELL_PROJECT_ID-minecraft-backup

echo BUCKET_NAME=$DEVSHELL_PROJECT_ID >> ~/.profile"

cd /home/minecraft
