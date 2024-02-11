setup: ## Setup the services, expects service=service_name
	@echo "Setting up $(service)"
ifeq ($(service),metallb)
	helm upgrade --install metallb-system --kube-context homeserver --create-namespace --namespace metallb-system --values metallb/values.yaml metallb
else ifeq ($(service),pihole)
	helm upgrade --install pihole --kube-context homeserver -n production --values pihole/production.yaml pihole
else
	@echo "Service not found."
endif

help: ## Show this help
	@echo "Usage: make [target]"
	@echo "Targets:"
	@awk -F ':.*?## ' '/:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
