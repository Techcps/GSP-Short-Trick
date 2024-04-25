

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)


cat > setup_mysql.sh <<EOF_CP
#!/bin/bash

# Update the packages and install MySQL using apt-get following command
sudo apt-get update
sudo apt-get install -y default-mysql-server

# Secure the database
sudo mysql_secure_installation <<EOF
N
Y
techcps 
N
N
N
Y
EOF

# Log in to the database
sudo mysql -u root -p <<MYSQL_LOGIN
techcps 
 SHOW databases;
 CREATE database petsdb;
 USE petsdb;
 CREATE TABLE pets (
     id INT AUTO_INCREMENT PRIMARY KEY,
     name VARCHAR(255),
     breed VARCHAR(255)
 );
 INSERT INTO pets (name, breed)
 VALUES ('Noir', 'Schnoodle');
 SELECT * FROM pets;
 exit
MYSQL_LOGIN

exit
EOF_CP



gcloud compute instances create mysql-db \
  --zone=$ZONE \
  --image-family debian-11 \
  --image-project debian-cloud \
  --boot-disk-size 10GB \
  --metadata-from-file startup-script=setup_mysql.sh \
  --tags mysql-server



gcloud compute instances create sql-server-db --zone=$ZONE --project=$PROJECT_ID --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=sql-server-db,image=projects/windows-sql-cloud/global/images/sql-2019-web-windows-2019-dc-v20230913,mode=rw,size=50,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any



gcloud compute instances create db-server --zone=$ZONE --project=$PROJECT_ID --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=startup-script=\#\!\ /bin/bash$'\n'apt-get\ update$'\n'apt-get\ install\ -y\ default-mysql-server,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=db-server,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230912,mode=rw,size=10,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


