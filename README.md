# Home Server

This is my kubernetes home server ops files, feel free to copy and use it.


## Tools

- A minimal Rocky Linux 9 VM in proxmox. 
- K3s single node cluster.
- K9s to manage the cluster from the outside.
- Helm to easily install/upgrade charts.

### Proxmox

- Remember to disable enterprise repository on pve -> Updates -> Repositories.

### K3s Cluster Installation Steps

Edit `/etc/systemd/system/k3s.service` and add `--disable=traefik` and `--disable=servicelb` to the `ExecStart` line.

Also remove the file `sudo rm /var/lib/rancher/k3s/server/manifests/traefik.yaml`

To remove all existing and klipper resources:
```bash
kubectl delete all -n kube-system --selector 'app=traefik'
kubectl delete all -n kube-system --selector 'app=klipper-lb'
```

Installing metallb, run the command `make setup service=metallb` then after run this to add the range of external IPs:
```bash
cat << 'EOF' | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
  - 10.10.10.201-10.10.10.255
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default-pool
EOF
```

#### Pihole
```bash
make setup service=pihole
```

### QBittorrent

Get nordvpn private key and edit the values file (must install wireguard-tools before):

```bash
nordvpn login --legacy
sudo wg show nordlynx private-key
```

Then paste the private key to the values env wireguard variable.
