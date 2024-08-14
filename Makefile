clean:
	rmdir /s /q demo-cicd
	del demo-cicd-default-networkpolicy.yaml
	del http-service-deployment.yaml
run:
	cd api && mvn clean package
	kompose convert
	helm create demo-cicd
	docker-compose build
	docker push pelado1998/demo-cicd:latest

