
# Virtual Private Networks (VPN)

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
export ZONE_1=
```
```
export ZONE_2=
```

```
export REGION_1="${ZONE_1%-*}"

export REGION_2="${ZONE_2%-*}"

gcloud compute networks create vpn-network-1 --subnet-mode custom
gcloud compute networks subnets create subnet-a \
--network vpn-network-1 --range 10.1.1.0/24 --region "$REGION_1"
gcloud compute firewall-rules create network-1-allow-custom \
--network vpn-network-1 \
--allow tcp:0-65535,udp:0-65535,icmp \
--source-ranges 10.0.0.0/8
gcloud compute firewall-rules create network-1-allow-ssh-icmp \
--network vpn-network-1 \
--allow tcp:22,icmp
gcloud compute instances create server-1 --machine-type=e2-medium --zone $ZONE_1 --subnet subnet-a

gcloud compute networks create vpn-network-2 --subnet-mode custom
gcloud compute networks subnets create subnet-b \
--network vpn-network-2 --range 192.168.1.0/24 --region $REGION_2
gcloud compute firewall-rules create network-2-allow-custom \
--network vpn-network-2 \
--allow tcp:0-65535,udp:0-65535,icmp \
--source-ranges 192.168.0.0/16
gcloud compute firewall-rules create network-2-allow-ssh-icmp \
--network vpn-network-2 \
--allow tcp:22,icmp
gcloud compute instances create server-2 --machine-type=e2-medium --zone $ZONE_2 --subnet subnet-b
```

## Perform task 4 using lab instruction 

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
