# Step 7 – Cloud GKE

**Objective:**

Provision a Kubernetes cluster on Google Kubernetes Engine (GKE) with Terraform, then synchronize the AI stack (FastAPI + Hugging Face) with ArgoCD using a GitOps workflow.

**Stack:**

- [Google Cloud Platform (GKE)](https://cloud.google.com/kubernetes-engine)
- [Terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)

**File structure:**

```
.
└── terraform/
│   ├── main.tf
│   ├── outputs.tf
├── argocd/   
│   ├── application-base.yaml
│   └── application-observability.yaml
```

**Notes:**

- The same `Application` manifests are reused from the local `k3d` setup.

**Deployment:**

> Requirements:  
> - You have `gcloud` CLI configured and authenticated.
> - You have `kubectl` and `terraform` installed.
> - Your GCP project, region and zone are configured (`gcloud config list`).

1. *Provision the GKE cluster*

```bash
cd terraform/

terraform init
terraform plan
terraform apply
cd ..
```

2. *Configure kubeconfig*

```bash
gcloud container clusters get-credentials k8s-ai-bootstrap
kubectl get nodes
```

3. *Install ArgoCD*

```bash
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

4. *Deploy Applications*

```bash
kubectl apply -f argocd/
```

**Validation:**

1. *Check ArgoCD Applications*

```bash
kubectl get applications -n argocd
```

> *Status should be `Synced` and `Healthy` for each Application.*

2. *Check resources*

The `ai-app` and `observability` resources should be created and running:

```bash
kubectl get all -n ai-app
kubectl get ingress,secrets -n ai-app
kubectl logs -n ai-app <pod-name>
```

```bash
kubectl get statefulsets,services,daemonsets,configmaps,deployments -n observability
```

> *See more in steps : [02-kubernetes-k3d.md](02-kubernetes-k3d.md) and [05-observability.md](05-observability.md).*

3. *Test GitOps*

You can follow **exactly** the validation steps in [06-gitops-argocd.md](06-gitops-argocd.md). In short, you will:

- Modify a manifest in `k8s/base/` (e.g., change `replicas`).

- Commit and push to the branch declared in `targetRevision`.

- Watch ArgoCD detect the diff and automatically synchronize the cluster state.

- Revert the commit in Git.

- Push the revert.

- Confirm that the cluster rolls back to match Git.

4. *Test API*

```bash
kubectl port-forward -n ai-app pod/<ai-api-pod-name> 8000:8000
```

```bash
curl -X POST http://127.0.0.1:8000/predict \
-H 'accept: application/json' \
-H "Content-Type: application/json" \
-d '{"text":"I love lifting heavy, sleeping well and watching One Piece."}'
```

5. *Clean up*

```bash
cd terraform/
terraform destroy
cd ..
```

> *Verify that no GCP resources remain to avoid unexpected billing.*