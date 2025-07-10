KUBECTL ?= kubectl
NAMESPACE ?= app-demo

apply:
	$(KUBECTL) apply -f 01-namespace.yaml
	$(KUBECTL) apply -f 02-secret-db.yaml
	$(KUBECTL) apply -f 03-pvc-postgres.yaml
	$(KUBECTL) apply -f 04-deployment-postgres.yaml
	$(KUBECTL) apply -f 05-deployment-api.yaml
	$(KUBECTL) apply -f 06-deployment-front.yaml
	$(KUBECTL) apply -f 07-services.yaml
	$(KUBECTL) apply -f 08-ingress.yaml

delete:
	-$(KUBECTL) delete -f 08-ingress.yaml
	-$(KUBECTL) delete -f 07-services.yaml
	-$(KUBECTL) delete -f 06-deployment-front.yaml
	-$(KUBECTL) delete -f 05-deployment-api.yaml
	-$(KUBECTL) delete -f 04-deployment-postgres.yaml
	-$(KUBECTL) delete -f 03-pvc-postgres.yaml
	-$(KUBECTL) delete -f 02-secret-db.yaml
	-$(KUBECTL) delete -f 01-namespace.yaml

status:
	$(KUBECTL) get all -n $(NAMESPACE)

logs-api:
	$(KUBECTL) logs -l app=api -n $(NAMESPACE)

logs-postgres:
	$(KUBECTL) logs -l app=postgres -n $(NAMESPACE)

logs-front:
	$(KUBECTL) logs -l app=front -n $(NAMESPACE)

build-api:
	docker build -t yourdockerhubuser/api-k3s:latest ./api

push-api:
	docker push yourdockerhubuser/api-k3s:latest
