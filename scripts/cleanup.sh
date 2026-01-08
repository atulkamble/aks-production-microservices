#!/bin/bash

# Cleanup script for AKS resources

set -e

echo "================================================"
echo "Cleaning up AKS resources"
echo "================================================"

# Delete Kubernetes resources
echo "Deleting Kubernetes resources..."
kubectl delete -f k8s/ --ignore-not-found=true

# Optional: Delete the entire namespace
read -p "Do you want to delete the 'prod' namespace? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    kubectl delete namespace prod --ignore-not-found=true
    echo "Namespace deleted."
fi

# Optional: Delete AKS cluster
read -p "Do you want to delete the AKS cluster? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    RESOURCE_GROUP="aks-prod-rg"
    az aks delete --resource-group $RESOURCE_GROUP --name aks-prod-cluster --yes --no-wait
    echo "AKS cluster deletion initiated."
    
    read -p "Do you want to delete the resource group? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        az group delete --name $RESOURCE_GROUP --yes --no-wait
        echo "Resource group deletion initiated."
    fi
fi

echo "================================================"
echo "Cleanup Complete!"
echo "================================================"
