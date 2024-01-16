
# [DEPRECATED] Multiple VPC Networks [GSP211]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
export REGION_2=
```
```
export ZONE=
```
```
export REGION=${ZONE::-2}
gcloud compute networks create managementnet --subnet-mode=custom
gcloud compute networks subnets create managementsubnet-$REGION --network=managementnet --region=$REGION --range=10.130.0.0/20
gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-$REGION --network=privatenet --region=$REGION --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-$REGION_2 --network=privatenet --region=$REGION_2 --range=172.20.0.0/20
gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0
gcloud compute instances create	managementnet-${REGION}-vm --zone=$ZONE --machine-type=e2-micro --subnet=managementsubnet-$REGION
gcloud compute instances create privatenet-${REGION}-vm --zone=$ZONE --machine-type=e2-micro --subnet=privatesubnet-$REGION
gcloud compute instances create vm-appliance --zone=$ZONE --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=privatesubnet-$REGION --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=managementsubnet-$REGION --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
