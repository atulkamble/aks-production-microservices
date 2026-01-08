.PHONY: help install run build docker-build docker-run docker-stop k8s-apply k8s-delete test clean

help:
	@echo "Available commands:"
	@echo "  make install       - Install Python dependencies"
	@echo "  make run           - Run Flask app locally"
	@echo "  make build         - Build Docker image"
	@echo "  make docker-run    - Run app in Docker"
	@echo "  make docker-stop   - Stop Docker containers"
	@echo "  make k8s-apply     - Apply all Kubernetes manifests"
	@echo "  make k8s-delete    - Delete all Kubernetes resources"
	@echo "  make test          - Run tests"
	@echo "  make clean         - Clean up temporary files"

install:
	cd app && pip install -r requirements.txt

run:
	cd app && python app.py

build:
	docker build -t atuljkamble/aks-prod-app:v1 ./app

docker-run:
	docker-compose up -d

docker-stop:
	docker-compose down

k8s-apply:
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/configmap.yaml
	kubectl apply -f k8s/secret.yaml
	kubectl apply -f k8s/deployment.yaml
	kubectl apply -f k8s/service.yaml
	kubectl apply -f k8s/ingress.yaml
	kubectl apply -f k8s/rbac.yaml
	kubectl apply -f k8s/hpa.yaml

k8s-delete:
	kubectl delete -f k8s/ --all

test:
	@echo "Running tests..."
	cd app && python -m pytest tests/ -v

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.log" -delete
