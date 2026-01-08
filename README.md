<div align="center">
<h1> 🚀 Kubernetes Production-Ready Project (AKS) </h1>
<p><strong>Built with ❤️ by <a href="https://github.com/atulkamble">Atul Kamble</a></strong></p>

<p>
<a href="https://codespaces.new/atulkamble/template.git">
<img src="https://github.com/codespaces/badge.svg" alt="Open in GitHub Codespaces" />
</a>
<a href="https://vscode.dev/github/atulkamble/template">
<img src="https://img.shields.io/badge/Open%20with-VS%20Code-007ACC?logo=visualstudiocode&style=for-the-badge" alt="Open with VS Code" />
</a>
<a href="https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/atulkamble/template">
<img src="https://img.shields.io/badge/Dev%20Containers-Ready-blue?logo=docker&style=for-the-badge" />
</a>
<a href="https://desktop.github.com/">
<img src="https://img.shields.io/badge/GitHub-Desktop-6f42c1?logo=github&style=for-the-badge" />
</a>
</p>

<p>
<a href="https://github.com/atulkamble">
<img src="https://img.shields.io/badge/GitHub-atulkamble-181717?logo=github&style=flat-square" />
</a>
<a href="https://www.linkedin.com/in/atuljkamble/">
<img src="https://img.shields.io/badge/LinkedIn-atuljkamble-0A66C2?logo=linkedin&style=flat-square" />
</a>
<a href="https://x.com/atul_kamble">
<img src="https://img.shields.io/badge/X-@atul_kamble-000000?logo=x&style=flat-square" />
</a>
</p>

<strong>Version 1.0.0</strong> | <strong>Last Updated:</strong> January 2026
</div>

```
cd /Users/atul/Downloads/aks-production-microservices/app && pip3 install -r requirements.txt

python3 app/app.py

# Test the running application
./scripts/test-local.sh

# Run with Docker
docker-compose up -d

# Build and push to Docker Hub (update image name first)
docker build -t atuljkamble/aks-prod-app:v1 ./app
docker push atuljkamble/aks-prod-app:v1

# Deploy to Azure AKS
./scripts/setup-aks.sh  # One-time cluster setup
./scripts/deploy.sh     # Deploy application

```

![Image](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/hybrid/media/aks-azure-architecture.png)

![Image](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks-microservices/images/microservices-architecture.svg)

![Image](https://platform9.com/media/kubernetes-constructs-concepts-architecture.jpg)

![Image](https://kubernetes.io/images/docs/kubernetes-cluster-architecture.svg)

![Image](https://phoenixnap.com/kb/wp-content/uploads/2021/04/full-kubernetes-model-architecture.png)

---

# 📁 GitHub Repo Structure

```
aks-production-microservices/
│
├── app/
│   ├── app.py
│   ├── Dockerfile
│
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── rbac.yaml
│
├── .github/workflows/
│   └── deploy.yaml
│
└── README.md
```

---

## 🧱 Project Overview

**Project Name:** `aks-production-microservices`
**Cloud:** Azure
**Kubernetes:** Azure Kubernetes Service
**App:** Python Flask API (can swap with Node/Java)
**CI/CD:** GitHub Actions
**Ingress:** NGINX Ingress Controller
**Security:** RBAC, NetworkPolicy, Secrets
**Observability:** Prometheus + Grafana
**Scaling:** HPA + Cluster Autoscaler

---

## 🏗️ Production Architecture

```
Internet
   |
Azure Load Balancer
   |
NGINX Ingress Controller
   |
Kubernetes Services (ClusterIP)
   |
Pods (ReplicaSets)
   |
Azure Managed Disk / Azure Files
```

---

## 👥 Kubernetes Roles & Responsibilities (IMPORTANT)

| Role                  | Responsibility                       |
| --------------------- | ------------------------------------ |
| **Cloud Architect**   | Infra design, AKS sizing, networking |
| **DevOps Engineer**   | CI/CD, manifests, automation         |
| **Platform Engineer** | Cluster security, policies           |
| **Developer**         | App, Dockerfile                      |
| **SRE**               | Monitoring, scaling, reliability     |
| **Security Engineer** | RBAC, secrets, policies              |

---

# 1️⃣ Cloud Architect – AKS Production Setup

## 🔹 Step 1: Resource Group

```bash
az group create \
  --name aks-prod-rg \
  --location eastus
```

---

## 🔹 Step 2: Create AKS Cluster (Production)

```bash
az aks create \
  --resource-group aks-prod-rg \
  --name aks-prod-cluster \
  --node-count 3 \
  --node-vm-size Standard_DS3_v2 \
  --enable-managed-identity \
  --enable-addons monitoring \
  --enable-cluster-autoscaler \
  --min-count 3 \
  --max-count 6 \
  --network-plugin azure \
  --generate-ssh-keys
```

✅ **Production Features Enabled**

* Managed Identity
* Autoscaling
* Azure CNI
* Monitoring

---

## 🔹 Step 3: Connect to Cluster

```bash
az aks get-credentials \
  --resource-group aks-prod-rg \
  --name aks-prod-cluster
```

```bash
kubectl get nodes
```

---

# 2️⃣ Developer – Application & Docker

## 🔹 Flask App (`app.py`)

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "AKS Production App Running!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

## 🔹 Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install flask
EXPOSE 5000
CMD ["python", "app.py"]
```

---

## 🔹 Build & Push Image

```bash
docker build -t atuljkamble/aks-prod-app:v1 .
docker push atuljkamble/aks-prod-app:v1
```

---

# 3️⃣ DevOps Engineer – Kubernetes Manifests

---

## 🔹 Namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prod
```

```bash
kubectl apply -f namespace.yaml
```

---

## 🔹 Deployment (Production Ready)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
  namespace: prod
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: flask
  template:
    metadata:
      labels:
        app: flask
    spec:
      containers:
      - name: flask
        image: atuljkamble/aks-prod-app:v1
        ports:
        - containerPort: 5000
        resources:
          requests:
            cpu: "200m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
```

---

## 🔹 Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: flask-service
  namespace: prod
spec:
  type: ClusterIP
  selector:
    app: flask
  ports:
  - port: 80
    targetPort: 5000
```

---

# 4️⃣ Platform Engineer – Ingress & Networking

![Image](https://docs.nginx.com/nic/ic-high-level.png)

![Image](https://learn.microsoft.com/en-us/azure/aks/media/concepts-network/aks-ingress.png)

## 🔹 Install NGINX Ingress

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx ingress-nginx/ingress-nginx
```

---

## 🔹 Ingress Resource

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: flask-ingress
  namespace: prod
spec:
  ingressClassName: nginx
  rules:
  - host: flask.prod.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: flask-service
            port:
              number: 80
```

---

# 5️⃣ Security Engineer – RBAC & Secrets

## 🔹 Secret

```bash
kubectl create secret generic app-secret \
  --from-literal=DB_PASSWORD=Prod@123 \
  -n prod
```

---

## 🔹 RBAC (Read-Only User)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: prod
  name: readonly
rules:
- apiGroups: [""]
  resources: ["pods","services"]
  verbs: ["get","list"]
```

---

# 6️⃣ SRE – Autoscaling & Monitoring

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2A0wJBUCAWTLAe62PHmhoLOQ.gif)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1200/1%2AqBwb4cI9dTYInvlo2oD3LA.png)

## 🔹 HPA

```bash
kubectl autoscale deployment flask-app \
  --cpu-percent=70 \
  --min=3 \
  --max=10 \
  -n prod
```

---

## 🔹 Prometheus + Grafana

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack
```

---

# 7️⃣ CI/CD – GitHub Actions

```yaml
name: AKS Deploy

on:
  push:
    branches: [ "main" ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    - run: |
        kubectl apply -f k8s/
```

---

# 8️⃣ Production Best Practices Checklist ✅

- ✔ Multi-node AKS
- ✔ Rolling updates
- ✔ Resource limits
- ✔ Secrets (no plain text)
- ✔ Ingress TLS ready
- ✔ Autoscaling
- ✔ Monitoring
- ✔ RBAC
- ✔ Namespace isolation

---

