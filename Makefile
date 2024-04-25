setup: ## Setup the services, expects parameter service=service_name
	@echo "Setting up $(service)"
ifeq ($(service),metallb)
	helm upgrade --install metallb-system --kube-context homeserver --create-namespace --namespace metallb-system --values k8s/metallb/values.yaml k8s/metallb
else ifeq ($(service),pihole)
	helm upgrade --install pihole --kube-context homeserver --create-namespace -n production --values pihole/production.yaml pihole
else ifeq ($(service),filebrowser)
	helm upgrade --install filebrowser --kube-context homeserver --create-namespace -n production --values filebrowser/production.yaml filebrowser
else ifeq ($(service),qbittorrent)
	helm upgrade --install qbittorrent --kube-context homeserver --create-namespace -n production --values qbittorrent/values.yaml qbittorrent
else ifeq ($(service),prometheus)
	helm upgrade --install prometheus --kube-context homeserver --create-namespace -n monitoring --values k8s/monitoring/kube-prometheus-stack/production.yaml k8s/monitoring/kube-prometheus-stack/
else ifeq ($(service),readarr)
	helm upgrade --install readarr --kube-context homeserver --create-namespace -n production --values readarr/production.yaml readarr
else
	@echo "Service not found."
endif

services: ## List available services to setup
	@echo "Services Available:"
	@echo "  - metallb"
	@echo "  - pihole"
	@echo "  - filebrowser"
	@echo "  - qbittorrent"
	@echo "  - prometheus"
	@echo "  - readarr"

help: ## Show this help
	@echo "Usage: make [target]"
	@echo "Targets:"
	@awk -F ':.*?## ' '/:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
