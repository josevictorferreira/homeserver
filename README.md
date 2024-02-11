# Home Server

This is my kubernetes home server ops files, feel free to copy and use it.


## Tools

- A minimal Centos 7 VM in proxmox. 
- K3s single node cluster.
- K9s to manage the cluster from the outside.
- Helm to easily install/upgrade charts.

### Proxmox

- Remember to disable enterprise repository on pve -> Updates -> Repositories.

### K3s Cluster

- Edit `/etc/systemd/system/k3s.service` and add `--disable traefik` and `disable servicelb` to the `ExecStart` line.

- To remove all existing and klipper resources:
```bash
kubectl delete all -n kube-system --selector 'app=traefik'
kubectl delete all -n kube-system --selector 'app=klipper-lb'
```

- Installing metallb, run the command `make setup service=metallb` then after run this to add the range of external IPs:
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

- Install ingress-nginx:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

#### Pihole
```bash
helm upgrade --install pihole -n production --values pihole/production.yaml pihole
```
