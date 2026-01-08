# 📋 Deployment Checklist

## Pre-Deployment

### Local Development
- [ ] Application runs successfully locally (`python app/app.py`)
- [ ] All endpoints return expected responses
- [ ] Unit tests pass (if applicable)
- [ ] Docker image builds successfully
- [ ] Docker container runs successfully
- [ ] Environment variables are properly configured

### Code Quality
- [ ] Code follows best practices
- [ ] No hardcoded secrets or credentials
- [ ] Error handling is implemented
- [ ] Logging is configured
- [ ] Health check endpoints are working

## Azure Setup

### Prerequisites
- [ ] Azure CLI installed (`az version`)
- [ ] Azure subscription is active
- [ ] kubectl installed (`kubectl version`)
- [ ] helm installed (`helm version`)
- [ ] Logged into Azure (`az login`)
- [ ] Docker Hub account created (or Azure Container Registry)

### AKS Cluster
- [ ] Resource group created
- [ ] AKS cluster created with appropriate size
- [ ] Managed identity enabled
- [ ] Autoscaling configured
- [ ] Monitoring enabled
- [ ] kubectl context set to AKS cluster
- [ ] Verify nodes are running (`kubectl get nodes`)

### Container Registry
- [ ] Docker image built
- [ ] Docker image tagged correctly
- [ ] Docker image pushed to registry
- [ ] Image pull secrets configured (if using private registry)

## Kubernetes Resources

### Namespace
- [ ] Namespace created (`kubectl get ns prod`)
- [ ] Namespace labels applied

### ConfigMap & Secrets
- [ ] ConfigMap created with correct values
- [ ] Secrets created with sensitive data
- [ ] Secrets are base64 encoded (if manual creation)
- [ ] No secrets in Git repository

### Application Deployment
- [ ] Deployment manifest updated with correct image
- [ ] Resource requests and limits set appropriately
- [ ] Replica count set (minimum 3 for production)
- [ ] Rolling update strategy configured
- [ ] Liveness probe configured
- [ ] Readiness probe configured
- [ ] Environment variables injected from ConfigMap/Secrets

### Service
- [ ] Service created and type is correct (ClusterIP)
- [ ] Service selector matches deployment labels
- [ ] Port mapping is correct

### Ingress
- [ ] NGINX Ingress Controller installed
- [ ] Ingress resource created
- [ ] Domain name configured (or using IP)
- [ ] TLS certificate configured (for HTTPS)
- [ ] Ingress rules are correct

### RBAC
- [ ] ServiceAccount created
- [ ] Roles defined with appropriate permissions
- [ ] RoleBindings created
- [ ] Principle of least privilege followed

### Horizontal Pod Autoscaler
- [ ] HPA resource created
- [ ] Metrics server installed
- [ ] CPU/Memory targets set appropriately
- [ ] Min and max replicas configured

## Monitoring & Observability

### Prometheus & Grafana
- [ ] Prometheus installed
- [ ] Grafana installed
- [ ] Dashboards configured
- [ ] Alerts configured
- [ ] Metrics are being collected

### Logging
- [ ] Application logging configured
- [ ] Log aggregation setup (if needed)
- [ ] Log rotation configured

## Security

### Application Security
- [ ] Container runs as non-root user
- [ ] Container image scanned for vulnerabilities
- [ ] Minimal base image used
- [ ] Secrets not in environment variables (use volumes)

### Network Security
- [ ] Network policies defined (if needed)
- [ ] Private endpoints configured (if needed)
- [ ] SSL/TLS certificates configured
- [ ] Firewall rules configured

### Access Control
- [ ] RBAC policies tested
- [ ] Service accounts have minimal permissions
- [ ] Azure AD integration configured (if needed)

## CI/CD Pipeline

### GitHub Actions
- [ ] GitHub repository secrets configured:
  - [ ] DOCKER_USERNAME
  - [ ] DOCKER_PASSWORD
  - [ ] AZURE_CREDENTIALS
- [ ] Workflow file is in `.github/workflows/`
- [ ] Workflow triggers on correct events
- [ ] Build step working
- [ ] Deploy step working
- [ ] Pipeline tested with test commit

## Post-Deployment Verification

### Application Health
- [ ] All pods are running (`kubectl get pods -n prod`)
- [ ] No pods are in CrashLoopBackOff
- [ ] Health endpoint returns 200
- [ ] Application logs show no errors

### Connectivity
- [ ] Service is accessible from within cluster
- [ ] Ingress is routing traffic correctly
- [ ] External access working (if configured)
- [ ] DNS resolution working

### Scaling
- [ ] HPA is active (`kubectl get hpa -n prod`)
- [ ] Manual scaling works
- [ ] Auto-scaling triggers correctly under load

### Monitoring
- [ ] Metrics visible in Prometheus
- [ ] Dashboards showing data in Grafana
- [ ] Alerts are firing when appropriate

## Load Testing

### Performance
- [ ] Load testing completed
- [ ] Response times acceptable
- [ ] Application scales under load
- [ ] No memory leaks observed
- [ ] Database connections managed properly

## Documentation

### Project Documentation
- [ ] README.md updated
- [ ] Architecture diagram included
- [ ] Deployment instructions clear
- [ ] Troubleshooting guide available

### Runbooks
- [ ] Deployment runbook created
- [ ] Rollback procedure documented
- [ ] Incident response plan documented
- [ ] Contact information updated

## Disaster Recovery

### Backup
- [ ] Backup strategy defined
- [ ] Database backups configured
- [ ] Configuration backups automated
- [ ] Backup restoration tested

### High Availability
- [ ] Multi-region deployment (if needed)
- [ ] Failover tested
- [ ] Recovery time objective (RTO) met
- [ ] Recovery point objective (RPO) met

## Cost Optimization

### Resource Management
- [ ] Resource requests optimized
- [ ] Autoscaling parameters tuned
- [ ] Unused resources identified
- [ ] Cost monitoring setup

## Compliance & Governance

### Compliance
- [ ] Security compliance checked
- [ ] Data residency requirements met
- [ ] Audit logging enabled
- [ ] Compliance reports generated

## Final Checks

### Pre-Go-Live
- [ ] All stakeholders notified
- [ ] Maintenance window scheduled
- [ ] Rollback plan ready
- [ ] Support team briefed
- [ ] Monitoring alerts configured

### Go-Live
- [ ] Deploy to production
- [ ] Smoke tests passed
- [ ] Monitor for 30 minutes post-deployment
- [ ] Verify all critical paths
- [ ] Update status page

### Post-Go-Live
- [ ] Monitor metrics for 24 hours
- [ ] Check error rates
- [ ] Review logs for issues
- [ ] Collect feedback
- [ ] Document lessons learned

---

## Quick Verification Commands

```bash
# Check cluster
kubectl cluster-info
kubectl get nodes

# Check application
kubectl get all -n prod
kubectl get pods -n prod -o wide
kubectl get svc -n prod
kubectl get ingress -n prod

# Check HPA
kubectl get hpa -n prod
kubectl top pods -n prod

# Check logs
kubectl logs -f deployment/flask-app -n prod

# Test endpoints
curl http://<ingress-ip>/
curl http://<ingress-ip>/health
curl http://<ingress-ip>/api/info
```

---

## Emergency Contacts

- **DevOps Lead:** [Name] - [Email] - [Phone]
- **Platform Engineer:** [Name] - [Email] - [Phone]
- **SRE On-Call:** [Name] - [Email] - [Phone]
- **Azure Support:** [Support Link]

---

**Last Updated:** January 8, 2026
**Version:** 1.0.0
