#!/bin/bash

# Deployment script for AKS Production Microservices

set -e

echo "================================================"
echo "Deploying to AKS Production"
echo "================================================"

# Apply Kubernetes manifests in order
echo "Creating namespace..."
kubectl apply -f k8s/namespace.yaml

echo "Creating ConfigMap..."
kubectl apply -f k8s/configmap.yaml

echo "Creating Secrets..."
kubectl apply -f k8s/secret.yaml

echo "Deploying RBAC policies..."
kubectl apply -f k8s/rbac.yaml

echo "Deploying application..."
kubectl apply -f k8s/deployment.yaml

echo "Creating service..."
kubectl apply -f k8s/service.yaml

echo "Creating ingress..."
kubectl apply -f k8s/ingress.yaml

echo "Setting up HPA..."
kubectl apply -f k8s/hpa.yaml

echo ""
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/flask-app -n prod --timeout=300s

echo ""
echo "================================================"
echo "Deployment Status"
echo "================================================"
kubectl get pods -n prod
kubectl get svc -n prod
kubectl get ingress -n prod
kubectl get hpa -n prod

echo ""
echo "================================================"
echo "Deployment Complete!"
echo "================================================"
