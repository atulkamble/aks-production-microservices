# 🚀 Quick Start Guide

## Local Development

### 1. Run with Python
```bash
# Install dependencies
cd app
pip install -r requirements.txt

# Run the application
python app.py
```

The application will be available at: `http://localhost:5000`

### 2. Run with Docker Compose (Recommended)
```bash
# Start the application
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the application
docker-compose down
```

### 3. Run with Make
```bash
# Install dependencies
make install

# Run locally
make run

# Run in Docker
make docker-run

# Stop Docker
make docker-stop
```

## Testing the Application

### Test Script
```bash
./scripts/test-local.sh
```

### Manual Testing
```bash
# Test root endpoint
curl http://localhost:5000/

# Test health endpoint
curl http://localhost:5000/health

# Test info endpoint
curl http://localhost:5000/api/info
```

### Expected Responses

**Root Endpoint (/):**
```json
{
  "message": "AKS Production App Running!",
  "status": "healthy",
  "timestamp": "2026-01-08T06:53:46.519630",
  "version": "v1.0.0"
}
```

**Health Endpoint (/health):**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-08T06:53:46.577382"
}
```

**Info Endpoint (/api/info):**
```json
{
  "application": "AKS Production Microservices",
  "environment": "development",
  "pod": "localhost"
}
```

## Deployment to Azure AKS

### Prerequisites
- Azure CLI installed and configured
- kubectl installed
- helm installed
- Docker Hub account (or Azure Container Registry)

### Step 1: Setup AKS Cluster
```bash
./scripts/setup-aks.sh
```

This script will:
- Create an Azure Resource Group
- Create an AKS cluster with autoscaling
- Install NGINX Ingress Controller
- Install Prometheus and Grafana for monitoring

### Step 2: Build and Push Docker Image
```bash
# Build the image
docker build -t <your-dockerhub-username>/aks-prod-app:v1 ./app

# Push to Docker Hub
docker push <your-dockerhub-username>/aks-prod-app:v1
```

### Step 3: Update Kubernetes Manifests
Update the image name in [k8s/deployment.yaml](k8s/deployment.yaml):
```yaml
containers:
- name: flask
  image: <your-dockerhub-username>/aks-prod-app:v1  # Update this line
```

### Step 4: Deploy to AKS
```bash
# Deploy all resources
./scripts/deploy.sh

# Or manually
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/rbac.yaml
kubectl apply -f k8s/hpa.yaml
```

### Step 5: Verify Deployment
```bash
# Check pods
kubectl get pods -n prod

# Check services
kubectl get svc -n prod

# Check ingress
kubectl get ingress -n prod

# Check HPA
kubectl get hpa -n prod

# View logs
kubectl logs -f deployment/flask-app -n prod
```

## GitHub Actions CI/CD

### Setup Secrets

1. **Docker Hub Credentials:**
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password or access token

2. **Azure Credentials:**
   ```bash
   az ad sp create-for-rbac --name "github-actions-aks" \
     --role contributor \
     --scopes /subscriptions/<subscription-id>/resourceGroups/aks-prod-rg \
     --sdk-auth
   ```
   Copy the JSON output and add it as `AZURE_CREDENTIALS` secret in GitHub.

3. Go to your repository Settings → Secrets and variables → Actions
4. Add the secrets

### Automatic Deployment

Once configured, every push to the `main` branch will:
1. Build the Docker image
2. Push to Docker Hub
3. Deploy to AKS

## Monitoring

### Access Grafana
```bash
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
```
Open: `http://localhost:3000`
- Username: `admin`
- Password: `prom-operator`

### Access Prometheus
```bash
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```
Open: `http://localhost:9090`

## Cleanup

### Delete Kubernetes Resources
```bash
./scripts/cleanup.sh
```

### Or Manually
```bash
# Delete all resources
kubectl delete -f k8s/

# Delete namespace
kubectl delete namespace prod

# Delete AKS cluster
az aks delete --resource-group aks-prod-rg --name aks-prod-cluster --yes

# Delete resource group
az group delete --name aks-prod-rg --yes
```

## Troubleshooting

### Application not starting
```bash
# Check pod status
kubectl get pods -n prod

# View logs
kubectl logs -f deployment/flask-app -n prod

# Describe pod
kubectl describe pod <pod-name> -n prod
```

### Ingress not working
```bash
# Check ingress
kubectl get ingress -n prod

# Check NGINX controller
kubectl get svc -n ingress-nginx

# View ingress logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

### HPA not scaling
```bash
# Check HPA status
kubectl get hpa -n prod

# Check metrics server
kubectl top nodes
kubectl top pods -n prod
```

## Production Best Practices Implemented

✅ **High Availability:**
- Multi-replica deployment (3 replicas)
- Pod anti-affinity rules
- Rolling updates with zero downtime

✅ **Security:**
- RBAC policies
- Secrets management
- Non-root container user
- Network policies ready

✅ **Scalability:**
- Horizontal Pod Autoscaler (HPA)
- Cluster Autoscaler
- Resource limits and requests

✅ **Monitoring:**
- Prometheus for metrics
- Grafana for visualization
- Application health checks

✅ **Reliability:**
- Liveness and readiness probes
- Graceful shutdown handling
- Automatic restart on failure

## Additional Resources

- [Azure Kubernetes Service Documentation](https://learn.microsoft.com/en-us/azure/aks/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Docker Documentation](https://docs.docker.com/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

## Support

For issues or questions, please open an issue in the GitHub repository.

---

**Built with ❤️ by [Atul Kamble](https://github.com/atulkamble)**
