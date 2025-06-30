# Step 2 - Deploy to Kubernetes (with k3d)

**Objective:**

Manually deploy the AI API to a local Kubernetes cluster using `k3d` and YAML manifests.

**Stack:**

- [k3d](https://k3d.io/)
- [Kubernetes](https://kubernetes.io/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

**File structure:**

```
.
├── k8s/
│   └── base/
│       ├── deployment.yaml
│       ├── ingress.yaml
│       ├── namespace.yaml
│       ├── secret.yaml
│       └── service.yaml
```

**Notes:**

- The `--port 80:80@loadbalancer` flag exposes port 80 of the local host to the internal k3d load balancer (Traefik by default). Without it, Ingress won’t be reachable from the machine.
- The AI API image is pushed to [Docker Hub](https://hub.docker.com/): `docker pull bilalguirre/ai-api:v1`
- Secrets are explained in [04-security-k8s.md](04-security-k8s.md)

**Deployment:**

```bash
k3d cluster create ai-bootstrap --port 80:80@loadbalancer
kubectl apply -f k8s/base/namespace.yaml
kubectl apply -f k8s/base/secret.yaml
kubectl apply -f k8s/base/deployment.yaml
kubectl apply -f k8s/base/service.yaml
kubectl apply -f k8s/base/ingress.yaml
````

**Validation:**

1. Check status:

```bash
kubectl get all -n ai-app
kubectl get ingress,secrets -n ai-app
```

2. Hosts file update

```bash
echo "127.0.0.1 local.ai-api" | sudo tee /etc/hosts
```

3. Send test requests:

```bash
curl -X 'POST' 'http://local.ai-api/predict' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"text": "I love meat and sports!"}'
```