# Step 9 – Ingress + TLS (Self-signed Certificate)

**Objective:**

Secure local access to the AI API with HTTPS using a self-signed TLS certificate, Traefik Ingress, and cert-manager.

**Stack:**

- [k3d](https://k3d.io/)
- [Traefik (Ingress Controller)](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)
- [cert-manager](https://cert-manager.io/)
- [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

**File structure:**

```
.
├── k8s/
│   ├── base/
│   │   ├── 05-clusterissuer.yaml
│   │   └── 09-ingress.yaml
```

**Notes:**

- Traefik is the default Ingress controller in `k3d`.
	- No need to install NGINX Ingress if Traefik is already available.
- Port 443 must be exposed when creating the cluster.
- `cert-manager` manages certificate lifecycle.
- `ClusterIssuer` issues self-signed certificates for HTTPS across the entire cluster.

**Deployment:**

1. Create the local cluster with HTTPS support:

```bash
k3d cluster create ai-bootstrap \
  --port 80:80@loadbalancer \
  --port 443:443@loadbalancer
```

2. Install `cert-manager`:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml

watch kubectl get all -n cert-manager
```

3. Apply base manifests:

```bash
kubectl apply -f k8s/base/
```

**Validation:**

1. Confirm the `ClusterIssuer` is ready:

```bash
kubectl get clusterissuers
```

2. Check all resources are deployed:

```bash
kubectl get ingress,secrets -n ai-app
```

*Check that a TLS secret has been issued for the Ingress.*

3. Test HTTP access:

```bash
curl 'http://local.ai-api/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"text": "I love cooking real food and learning something new every day."}'
```

4. Test HTTPS access (ignore self-signed warning):

```bash
curl -k 'https://local.ai-api/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{"text": "I hate Uber Eats and endless TikToks."}'
```

**Next:**

- Replace self-signed certificates with Let's Encrypt  
- Test on GKE