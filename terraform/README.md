# Terraform - GKE Minimal

**Objective:**

Provision a minimal GKE cluster via Terraform.  

**Stack:**

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/) - IaC for Google Cloud

**File structure:**

```
.
└── terraform/
    ├── main.tf
    ├── outputs.tf
```

**Requirements:**

- `gcloud` CLI authenticated:

```bash
gcloud auth application-default login
```

**Deployment:**

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

**Validation:**

```bash
# Connect kubeconfig:
gcloud container clusters get-credentials k8s-ai-bootstrap
kubectl get nodes

terraform output
```