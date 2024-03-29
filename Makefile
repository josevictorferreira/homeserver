setup: ## Setup the services, expects parameter service=service_name
	@echo "Setting up $(service)"
ifeq ($(service),metallb)
	helm upgrade --install metallb-system --kube-context homeserver --create-namespace --namespace metallb-system --values k8s/metallb/values.yaml k8s/metallb
else ifeq ($(service),pihole)
	helm upgrade --install pihole --kube-context homeserver --create-namespace -n production --values pihole/production.yaml pihole
else ifeq ($(service),filebrowser)
	helm upgrade --install filebrowser --kube-context homeserver --create-namespace -n production --values filebrowser/production.yaml filebrowser
else
	@echo "Service not found."
endif

help: ## Show this help
	@echo "Usage: make [target]"
	@echo "Targets:"
	@awk -F ':.*?## ' '/:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
