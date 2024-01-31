# Home Server

This is my kubernetes home server ops files, feel free to copy and use it.


### Tools

- A minimal Centos 7 VM in proxmox. 
- K3s single node cluster.
- K9s to manage the cluster from the outside
- Helm to easily install/upgrade charts


### Setup

#### Pihole
```bash
helm upgrade --install pihole -n production --values pihole/production.yaml pihole
```
