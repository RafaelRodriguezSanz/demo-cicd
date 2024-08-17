clean:
	rmdir /s /q demo-cicd
	del demo-cicd-default-networkpolicy.yaml
	del http-service-deployment.yaml

.PHONY: all build push start-minikube install-argocd port-forward deploy

all: build push start-minikube install-argocd port-forward deploy

# Paso 1: Compilar la aplicación Java
build:
	cd api && mvn clean package

# Paso 2: Convertir el Docker Compose a archivos de Kubernetes con Kompose
convert:
	kompose convert

# Paso 3: Crear un Chart de Helm
create-helm-chart:
	helm create demo-cicd

# Paso 4: Construir la imagen Docker usando Docker Compose
docker-build:
	docker-compose build

# Paso 5: Subir la imagen a Docker Hub
push:
	docker push pelado1998/demo-cicd:latest

# Paso 6: Iniciar Minikube en segundo plano
start-minikube:
	minikube start
	@echo "Esperando que Minikube se inicie..."
	@sleep 30 # Espera un poco para asegurar que Minikube se inicie

# Paso 7: Crear el namespace para ArgoCD en Minikube
create-namespace:
	minikube kubectl -- create namespace argocd

# Paso 8: Aplicar los manifiestos de instalación de ArgoCD
install-argocd: create-namespace
	minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Paso 9: Exponer el servicio de ArgoCD para acceso local
port-forward:
	minikube kubectl -- port-forward svc/argocd-server -n argocd 8080:443
	@echo "Esperando que el port-forwarding se establezca..."
	@sleep 30 # Espera un poco para asegurar que el port-forwarding se establezca


# Paso 11: Aplicar el manifiesto de la aplicación en ArgoCD
deploy:
	minikube kubectl -- apply -f application.yaml -n argocd



