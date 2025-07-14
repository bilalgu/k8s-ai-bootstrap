# Step 8 – Scalability with HPA

**Objective:**

Enable horizontal scaling for the AI API using a `HorizontalPodAutoscaler` (HPA).  

**Stack:**

- [Kubernetes HorizontalPodAutoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)

**File structure:**

```
.
├── k8s/
│   ├── base/
│   │   ├── 06-deployment.yaml
│   │   └── 08-hpa.yaml
```

**Notes:**

- The `Deployment` manifest defines `resources.requests` and `resources.limits` for CPU and memory.
	- *Without `requests`, the HPA cannot calculate CPU utilization.*
	- *Check your Pod’s actual consumption before setting requests/limits:*

```bash
kubectl top pod -n ai-app
```

- The HPA can be tested both locally (`k3d`) and on GKE.

**Deployment:**

All resources for scaling (Deployment, Service, HPA) are declared in Git and synchronized automatically by ArgoCD.

> Reference: [Step 6 – GitOps with ArgoCD](docs/06-gitops-argocd.md)

Requirements:
- `ArgoCD` is deployed and running.
- `metrics-server` is available in the cluster.

```bash
# Check metrics-server is working
kubectl top pod -A
```

**Validation:**

1. *Observe HPA behavior*

```bash
watch kubectl get hpa -n ai-app
```

```bash
watch kubectl get pods -n ai-app
```

2. Bonus: You can have fun and generate load to see.

*(You can run multiple clients in parallel if you want, tmux is a nice tool for that!)*

```bash
kubectl run -it --rm --image=alpine/curl test-client -- /bin/sh
```

```bash
while true; do
  curl -X POST http://ai-api-service.ai-app:80/predict \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"text": "I love One Piece!"}'
done
```