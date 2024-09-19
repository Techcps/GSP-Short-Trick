

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

export REGION_1="${ZONE_1%-*}"

export REGION_2="${ZONE_2%-*}"

export REGION_3="${ZONE_3%-*}"


gcloud compute instances create us-test-01 \
--subnet subnet-$REGION_1 \
--zone $ZONE_1 \
--machine-type e2-standard-2 \
--tags ssh,http,rules

gcloud compute instances create us-test-02 \
--subnet subnet-$REGION_2 \
--zone $ZONE_2 \
--machine-type e2-standard-2 \
--tags ssh,http,rules

gcloud compute instances create us-test-03 \
--subnet subnet-$REGION_3 \
--zone $ZONE_3 \
--machine-type e2-standard-2 \
--tags ssh,http,rules


gcloud compute instances create us-test-04 \
--subnet subnet-$REGION_1 \
--zone $ZONE_1 \
--tags ssh,http



cat > cp1.sh <<'EOF_CP'
sudo apt-get update
sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
traceroute www.icann.org

EOF_CP


cat > cp2.sh <<'EOF_CP'
sudo apt-get update

sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
EOF_CP


cat > cp4.sh <<'EOF_CP'
sudo apt-get update

sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege

EOF_CP



gcloud compute scp cp1.sh us-test-01:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --quiet

gcloud compute ssh us-test-01 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --quiet --command="bash /tmp/cp1.sh"

sleep 10


gcloud compute scp cp2.sh us-test-02:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_2 --quiet

gcloud compute ssh us-test-02 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_2 --quiet --command="bash /tmp/cp2.sh"

sleep 10

gcloud compute scp cp4.sh us-test-04:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --quiet

gcloud compute ssh us-test-04 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --quiet --command="bash /tmp/cp4.sh"

