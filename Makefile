KUBECTL ?= kubectl
NAMESPACE ?= app-demo

# Variables
API_IMAGE=simple-api-pg
API_DIR=./api

.PHONY: all build-api import-api apply delete status logs-api logs-postgres logs-front deploy

# Build l'image de l'API localement
build-api:
	@docker build -t $(API_IMAGE) $(API_DIR)

# Importe l'image dans le containerd de K3s
import-api:
	@docker save $(API_IMAGE) | sudo k3s ctr images import -

# Appliquer tous les manifests K3s
apply:
	@$(KUBECTL) apply -f 01-namespace.yaml
	@$(KUBECTL) apply -f 02-secret-db.yaml
	@$(KUBECTL) apply -f 03-pvc-postgres.yaml
	@$(KUBECTL) apply -f 04-deployment-postgres.yaml
	@$(KUBECTL) apply -f 05-deployment-api.yaml
	@$(KUBECTL) apply -f 06-deployment-front.yaml
	@$(KUBECTL) apply -f 07-services.yaml
	@$(KUBECTL) apply -f 08-ingress.yaml

# Supprimer les ressources (dans l’ordre inverse)
delete:
	-@$(KUBECTL) delete -f 08-ingress.yaml
	-@$(KUBECTL) delete -f 07-services.yaml
	-@$(KUBECTL) delete -f 06-deployment-front.yaml
	-@$(KUBECTL) delete -f 05-deployment-api.yaml
	-@$(KUBECTL) delete -f 04-deployment-postgres.yaml
	-@$(KUBECTL) delete -f 03-pvc-postgres.yaml
	-@$(KUBECTL) delete -f 02-secret-db.yaml
	-@$(KUBECTL) delete -f 01-namespace.yaml

# Afficher les ressources
status:
	@$(KUBECTL) get all -n $(NAMESPACE)

# Logs utiles
logs-api:
	@$(KUBECTL) logs -l app=api -n $(NAMESPACE)

logs-postgres:
	@$(KUBECTL) logs -l app=postgres -n $(NAMESPACE)

logs-front:
	@$(KUBECTL) logs -l app=front -n $(NAMESPACE)

# Déploiement complet
deploy: build-api import-api apply
