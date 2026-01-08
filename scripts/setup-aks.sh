#!/bin/bash

# AKS Production Setup Script
# This script automates the creation of AKS cluster with production-ready settings

set -e

# Configuration
RESOURCE_GROUP="aks-prod-rg"
CLUSTER_NAME="aks-prod-cluster"
LOCATION="eastus"
NODE_COUNT=3
NODE_SIZE="Standard_DS3_v2"
MIN_COUNT=3
MAX_COUNT=6

echo "================================================"
echo "AKS Production Cluster Setup"
echo "================================================"

# Step 1: Create Resource Group
echo "Creating resource group: $RESOURCE_GROUP..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Step 2: Create AKS Cluster
echo "Creating AKS cluster: $CLUSTER_NAME..."
az aks create \
  --resource-group $RESOURCE_GROUP \
  --name $CLUSTER_NAME \
  --node-count $NODE_COUNT \
  --node-vm-size $NODE_SIZE \
  --enable-managed-identity \
  --enable-addons monitoring \
  --enable-cluster-autoscaler \
  --min-count $MIN_COUNT \
  --max-count $MAX_COUNT \
  --network-plugin azure \
  --generate-ssh-keys \
  --zones 1 2 3

# Step 3: Get Credentials
echo "Getting AKS credentials..."
az aks get-credentials \
  --resource-group $RESOURCE_GROUP \
  --name $CLUSTER_NAME \
  --overwrite-existing

# Step 4: Verify Cluster
echo "Verifying cluster..."
kubectl get nodes

# Step 5: Install NGINX Ingress Controller
echo "Installing NGINX Ingress Controller..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  --set controller.replicaCount=2 \
  --set controller.nodeSelector."kubernetes\.io/os"=linux \
  --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux

# Step 6: Install Monitoring Stack (Optional)
echo "Installing Prometheus and Grafana..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack \
  --create-namespace \
  --namespace monitoring

echo "================================================"
echo "AKS Cluster Setup Complete!"
echo "================================================"
echo "Cluster Name: $CLUSTER_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"
echo ""
echo "Next steps:"
echo "1. Deploy your application: kubectl apply -f k8s/"
echo "2. Check deployment: kubectl get pods -n prod"
echo "3. Access Grafana: kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80"
echo "================================================"
