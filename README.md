# k8s-ai-bootstrap - Stack Kubernetes IA prête à déployer

> Une API IA containérisée, déployable localement **ou dans le cloud**, dans un cluster Kubernetes sécurisé et automatisé, pour **gagner du temps et éviter les erreurs**.


Je développe ce projet pour **aider les CTOs, startups tech et freelances** à :

- **Mettre en ligne rapidement** une API IA (FastAPI + Hugging Face)
    
- Comprendre et maîtriser chaque brique Kubernetes (namespace, RBAC, ingress…)
    
- Disposer d’une base **cloud-native, sécurisée et automatisable** grâce au **CI/CD** et **GitOps**
    
- **Porter la stack** du local (`k3d`) vers un vrai cluster **GKE** avec **Terraform**
    
- **Éviter les erreurs manuelles** grâce à une infra reproductible et documentée

En clair : **gagner du temps, réduire le stress opérationnel, et itérer proprement**.


## Ce que contient cette stack (v1.3.0+)

- **Application IA FastAPI** — Exemple minimaliste : _sentiment analysis_ via Hugging Face
    
- **Docker** — Containerisation reproductible et versionnée
    
- **Cluster Kubernetes local `k3d`** — Pour tout comprendre à la main
    
- **Cluster GKE cloud** — Provisionné avec **Terraform**, pour valider l’extension cloud-ready
    
- **Manifests K8s écrits à la main** — Namespace, Deployment, Service, Ingress
    
- **GitOps avec ArgoCD** — Déploiement déclaratif, rollback et prune automatiques
    
- **HorizontalPodAutoscaler (HPA)** — Scalabilité auto en fonction de la charge
    
- **CI/CD GitHub Actions** — Pipeline pour builder/pusher l’image Docker
    
- **RBAC, Secrets, NetworkPolicy** — Sécurité et isolation réseau dès la base
    
- **Loki + Promtail + Grafana** — Centralisation et visualisation des logs K8s


## À qui ça s’adresse ?

**1. CTOs et startups tech** qui veulent :

- Tester ou déployer une API IA sans galère infra
    
- Une base **Kubernetes claire, modulaire et scalable**
    
- Monter en compétence sur la mise en prod cloud-native
    
- Industrialiser rapidement un **POC IA containerisé**

**2. Freelances ou devs DevOps** qui veulent :

- Un **exemple concret** pour industrialiser un microservice IA
    
- Une base pour étendre à un cluster **cloud public** sans repartir de zéro


## Objectifs du projet (version originale)

A minimalist, modular Kubernetes stack that deploys an AI API with built-in security, observability, and automated CI/CD.

This project is both:
- a **public portfolio** for Kubernetes, GitOps and Cloud Security practices
- a **hands-on playground** to master K8s concepts step by step
- a **base stack** you can adapt for real-world freelance projects

### Quick Start

#### Option A – Deploy Manually (Learn)

```bash
# Create your local cluster
k3d cluster create ai-bootstrap --port 80:80@loadbalancer

# Apply manifests manually
kubectl apply -f k8s/base/
kubectl apply -f k8s/observability/

# Check
kubectl get all -n ai-app
kubectl get all -n observability
```

#### Option B – Deploy GitOps (Recommended)

> Use ArgoCD to manage everything from Git.  
> Requires your cluster to exist (`k3d` for local or `GKE` for cloud).

```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Apply ArgoCD Applications
kubectl apply -f argocd/

# Check sync status
kubectl get applications -n argocd
```

> Full steps → [Step 6 – GitOps with ArgoCD](docs/06-gitops-argocd.md)
>
> Cloud version → [Step 7 – Cloud GKE](docs/07-cloud-gke.md)

### Test your API

```bash
kubectl port-forward -n ai-app pod/<pod-name> 8000:8000

curl -X POST http://127.0.0.1:8000/predict \
-H 'accept: application/json' \
-H "Content-Type: application/json" \
-d '{"text":"I love lifting heavy, sleeping well and watching One Piece."}'
```

or

```bash
echo "127.0.0.1 local.ai-api" | sudo tee /etc/hosts

curl -X 'POST' 'http://local.ai-api/predict' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"text": "I hate McDo, chips and wasting hours on dumb series."}'
```

### Test logs in Grafana

- Port-forward Grafana:  

```bash
kubectl port-forward -n observability svc/grafana 3000:3000
```

- Open [http://localhost:3000](http://localhost:3000) (admin/admin)

- Add Loki as datasource → run `{job="varlogs"}`

### CI/CD Pipeline

This project uses GitHub Actions to:

- Build and push the Docker image automatically when code changes in `app/`

- Keep images versioned and up-to-date on Docker Hub

- Validate the pipeline on test branches before merging to `main`

### Detailed Docs

- [Step 1 – AI API with FastAPI + Hugging Face](docs/01-ai-api-fastapi.md)
- [Step 2 – Deploy to Kubernetes (k3d)](docs/02-kubernetes-k3d.md)
- [Step 3 – CI/CD with GitHub Actions](docs/03-ci-cd-github-actions.md)
- [Step 4 – Kubernetes Security](docs/04-security-k8s.md)
- [Step 5 – Observability with Loki, Promtail & Grafana](docs/05-observability.md)
- [Step 6 – GitOps with ArgoCD](docs/06-gitops-argocd.md)
- [Step 7 – Cloud GKE](docs/07-cloud-gke.md)
- [Step 8 – Scalability with HPA](docs/08-scalability-hpa.md)

➡️ See the [ROADMAP](ROADMAP.md) for upcoming features.

📌 See [CONVENTION](CONVENTION.md) for current naming rules.


## Qui suis-je

Je m'appelle Bilal. 
J’aime bâtir des infrastructures **robustes, lisibles et sécurisées**, des fondations qui tiennent la route, et qui permettent d’itérer vite et bien.

Si vous voulez :
- Tester ce projet,
- L’adapter à votre POC IA,
- Ou automatiser et sécuriser vos propres déploiements cloud,

📬 **Écrivez-moi :**
## Me contacter

- 🔗 [Mon LinkedIn](https://www.linkedin.com/in/bilal-guirre-395544221/)
- 📧 bilal.guirre.pro@proton.me
