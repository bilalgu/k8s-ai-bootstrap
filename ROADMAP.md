# Roadmap – k8s-ai-bootstrap

## Version 1.0.0

| Area          | Objective                                                                     |
| ------------- | ----------------------------------------------------------------------------- |
| App           | Build a sentiment analysis API with FastAPI + Transformers                    |
| Container     | Dockerize the app, push image to Docker Hub                                   |
| Kubernetes    | Deploy the app on a local `k3d` cluster with manifests                        |
| Ingress       | Expose the API via Ingress with a custom local domain (`local.ai-api`)        |
| CI/CD         | Automate Docker image build & push using GitHub Actions                       |
| Security      | Implement RBAC, manage secrets securely, add basic NetworkPolicy              |
| Observability | Deploy Loki + Promtail + Grafana dashboards to collect and visualize app logs |
| Monitoring    | Add readiness in Deployment                                                   |
| Documentation | Extend README and create docs ?                                               |

***

## Future ideas

| Area         | Objective                                                         |
| ------------ | ----------------------------------------------------------------- |
| GitOps       | Integrate ArgoCD or Flux for declarative GitOps-based deployments |
| Cloud-ready  | Prepare Terraform files to deploy the same stack on EKS/GKE       |
| Scalability  | Support multi-app deployment, HTTPS with TLS certs                |
| Advanced Sec | Add image vulnerability scanning, OPA/Gatekeeper policies         |
| Performance  | Benchmark resource usage and optimize containers/pods             |
