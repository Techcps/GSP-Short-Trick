

echo "Export the variables name correctly"

# Set the ZONE name correctly
read -p "Enter ZONE: " ZONE

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

gcloud sql instances create wordpress --tier=db-n1-standard-1 --activation-policy=ALWAYS --zone $ZONE

gcloud sql users set-password --host % root --instance wordpress --password Password1*

ADDRESS=$(gcloud compute instances describe blog --zone=$ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")/32

gcloud sql instances patch wordpress --authorized-networks $ADDRESS --quiet

cat > cp.sh <<'EOF_CP'

sudo apt-get update
sudo apt-get install -y mysql-client

gcloud auth login --no-launch-browser --quiet

echo 'Password1*' | mysql_config_editor set --login-path=local --host=$MYSQLIP --user=root --password

MYSQLIP=$(gcloud sql instances describe wordpress --format="value(ipAddresses.ipAddress)")

export MYSQL_PWD=Password1*

mysql --host=$MYSQLIP --user=root << EOF
CREATE DATABASE wordpress;
CREATE USER 'blogadmin'@'%' IDENTIFIED BY 'Password1*';
GRANT ALL PRIVILEGES ON wordpress.* TO 'blogadmin'@'%';
FLUSH PRIVILEGES;
EOF

sudo mysqldump -u root -pPassword1* wordpress > wordpress_backup.sql

mysql --host=$MYSQLIP --user=root -pPassword1* --verbose wordpress < wordpress_backup.sql

sudo service apache2 restart

cd /var/www/html/wordpress

EXTERNAL_IP=$(gcloud sql instances describe wordpress --format="value(ipAddresses[0].ipAddress)")

CONFIG_FILE="wp-config.php"

sudo sed -i "s/define('DB_HOST', 'localhost')/define('DB_HOST', '$EXTERNAL_IP')/" $CONFIG_FILE

EOF_CP

gcloud compute scp cp.sh blog:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh blog --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp.sh"

