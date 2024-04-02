
sudo apt-get update -y

sudo apt-get install libpcre3-dbg libpcre3-dev autoconf automake libtool libpcap-dev libnet1-dev libyaml-dev zlib1g-dev libcap-ng-dev libmagic-dev libjansson-dev libjansson4 -y

sudo apt-get install libnspr4-dev -y

sudo apt-get install libnss3-dev -y

sudo apt-get install liblz4-dev -y

sudo apt install rustc cargo -y

sudo add-apt-repository ppa:oisf/suricata-stable -y

sudo apt-get update -y

sudo apt-get install suricata -y

suricata -V

sudo systemctl stop suricata

sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.backup

wget https://storage.googleapis.com/tech-academy-enablement/GCP-Packet-Mirroring-with-OpenSource-IDS/suricata.yaml

wget https://storage.googleapis.com/tech-academy-enablement/GCP-Packet-Mirroring-with-OpenSource-IDS/my.rules

sudo mkdir /etc/suricata/poc-rules

sudo cp my.rules /etc/suricata/poc-rules/my.rules

sudo cp suricata.yaml /etc/suricata/suricata.yaml

sudo systemctl start suricata

sudo systemctl restart suricata

cat /etc/suricata/poc-rules/my.rules

