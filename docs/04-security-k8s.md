# Step 4 – Kubernetes Security

**Objective:**

Add a minimal security layer to the Kubernetes cluster to follow good practices:
- Restrict user permissions (RBAC)
- Store sensitive data securely (Secrets)
- Control network traffic (NetworkPolicy)

**Stack:**

- [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

**File structure:**

```
.  
├── k8s/
│   └── base/
│   │   ├── 02-rbac.yaml
│   │   ├── 03-secret.yaml
│   │   ├── 04-networkpolicy.yaml
```

**Notes:**

- `RBAC` defines what a user can do in the `ai-app` namespace.
- `Secrets` store sensitive values in base64 and inject them into the container.
- **The `secret.yaml` must be applied before `deployment.yaml`**, because the deployment references it to inject the secret value.
- `NetworkPolicy` restricts incoming traffic to only allow HTTP requests on port `8000`.
- The file prefixes `01-`, `02-`, … ensure that `kubectl apply -f k8s/base/` runs in the right order.

**Deployment:**

> Requirements: the cluster must already be deployed (cf. [02-kubernetes-k3d.md](02-kubernetes-k3d.md)).  
> 
> ⚠️ **Important:** Always apply `secret.yaml` **before** `deployment.yaml` or reapply the deployment to refresh env variables.

Apply all resources:

```bash
kubectl apply -f k8s/base/02-rbac.yaml
kubectl apply -f k8s/base/03-secret.yaml
kubectl apply -f k8s/base/04-networkpolicy.yaml
````

**Validation:**

1. Check status:

```bash
kubectl get roles,rolebindings,secrets,networkpolicies -n ai-app
```

2. *RBAC*

```bash
kubectl auth can-i get pods --as bilal -n ai-app
kubectl auth can-i create pods --as bilal -n ai-app
```

3. *Secrets*

```bash
kubectl exec -it -n ai-app <pod-name> -- env | grep API_KEY
```

4. *NetworkPolicy*

```bash
kubectl run test-client --rm -it --image alpine/curl -- /bin/sh
```

```bash
curl ai-api-service.ai-app:80

# Modify the allowed port in networkpolicy.yaml to test blocking
```

And you can always test from your local machine:

```bash
curl -X 'POST' 'http://local.ai-api/predict' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"text": "I love One Piece!"}'
```