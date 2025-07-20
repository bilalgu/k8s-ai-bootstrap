# Step 6 – GitOps ArgoCD

**Objective:**

Use Git as the single source of truth and automate sync with ArgoCD.

**Stack:**

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)

**File structure:**

```
.
├── argocd/       
│   ├── application-base.yaml                  
│   └── application-observability.yaml
└── k8s/
    ├── base/
    └── observability/
```

- `argocd/` contains ArgoCD `Application` manifests.
- `k8s/` contains versioned resources for each namespace.

**Notes:**

- **ArgoCD will install and synchronize the workloads, no need to `kubectl apply` your manifests manually !!**
- Each `Application` watches a specific path (`k8s/base` or `k8s/observability`) and syncs to its namespace.
- `targetRevision` defines which branch ArgoCD watches (`main`, `HEAD` or a test branch).
- `prune: true` ensures that any resource not in Git is deleted → cluster always equals Git.

**Deployment:**

1. Create namespace & install ArgoCD:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
````

2. Apply the ArgoCD Applications:

```bash
kubectl apply -f argocd/
```

3. Verify Applications:

```bash
kubectl get applications -n argocd
```

**Validation:**

1. *Sync test*

Use a test branch:

```bash
git checkout -b gitops-test
sed -i 's/targetRevision: main/targetRevision: gitops-test/' argocd/application-*.yaml
kubectl apply -f argocd/
```

Modify a manifest:

```bash
sed -i 's/replicas: 1/replicas: 2/' k8s/base/07-deployment.yaml
git add k8s/base/07-deployment.yaml
git commit -m "increase replicas"
git push -u origin gitops-test
date
```

Watch ArgoCD sync:

```bash
while true; do kubectl get pods -n ai-app; sleep 10; done
date -d $(kubectl describe applications -n argocd ai-app | grep -e "Finished At" | sed 's/    Finished At:  //')
```

> *It takes approximately 3 min for ArgoCD to detect a diff and apply it.*

```
jeu. 10 juil. 2025 11:24:21 CEST
jeu. 10 juil. 2025 11:26:05 CEST
```

2. *Rollback*

Revert the commit:

```bash
git revert gitops-test
git push

date
while true; do kubectl get pods -n ai-app; sleep 10; done
date -d $(kubectl describe applications -n argocd ai-app | grep -e "Finished At" | sed 's/    Finished At:  //')
```

3. *Prune*

Create a configmap:

```bash
cat <<EOF > k8s/base/10-configmap-test.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: test
  namespace: ai-app
data:
  foo: bar
EOF
```

Check that ArgoCD creates it:

```bash
git add k8s/base/10-configmap-test.yaml
git commit -m "add configmap for prune test"
git push

date
while true; do kubectl get configmaps -n ai-app; sleep 10; done
date -d $(kubectl describe applications -n argocd ai-app | grep -e "Finished At" | sed 's/    Finished At:  //')
```

Remove the configmap from Git → ArgoCD should prune it:

```bash
rm k8s/base/10-configmap-test.yaml

git add k8s/base/10-configmap-test.yaml
git commit -m "remove configmap to test prune"
git push

date
while true; do kubectl get configmaps -n ai-app; sleep 10; done
date -d $(kubectl describe applications -n argocd ai-app | grep -e "Finished At" | sed 's/    Finished At:  //')
```

**Potential improvements:**

- ArgoCD Core only: If you do not need the full UI, SSO, or multi-cluster management, you can deploy only the core Argo CD components.