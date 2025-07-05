# Roadmap – k8s-ai-bootstrap

## ✅ Version 1.0.0 – Delivered

| Area          | Objective                                                                     |
| ------------- | ----------------------------------------------------------------------------- |
| App           | Build a sentiment analysis API with FastAPI + Transformers                    |
| Container     | Dockerize the app, push image to Docker Hub                                   |
| Kubernetes    | Deploy the app on a local `k3d` cluster with manifests                        |
| Ingress       | Expose the API via Ingress with a custom local domain (`local.ai-api`)        |
| CI/CD         | Automate Docker image build & push using GitHub Actions                       |
| Security      | Implement RBAC, manage secrets securely, add basic NetworkPolicy              |
| Observability | Deploy Loki + Promtail + Grafana dashboards to collect and visualize app logs |
| Documentation | Extend README and create modular docs                                         |

> ***Monitoring** : Readiness/Liveness probes dropped for now → not critical for MVP*

***
## Version 2.0.0 – Next focus

| Area         | Objective                                                           |
| ------------ | ------------------------------------------------------------------- |
| GitOps       | Integrate ArgoCD or Flux for pull-based, declarative deployments    |
| Cloud-ready  | Use Terraform to deploy the stack on a real cloud cluster (EKS/GKE) |
| Scalability  | Add HorizontalPodAutoscaler for the FastAPI deployment              |
| TLS/Ingress  | Use an Ingress Controller + cert-manager for automatic HTTPS certs  |
| Scenario     | Add a realistic Use Case (multi-app or backend API as a Service)    |
| Advanced Sec | Add image vulnerability scanning + OPA/Gatekeeper policies          |
| Monitoring   | Add Prometheus for metrics + integrate with Grafana dashboards      |
| Docs         | Update architecture diagrams, workflows, and scenario documentation |
