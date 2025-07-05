# k8s-ai-bootstrap — Stack Kubernetes IA prête à déployer

> Déployez une API IA containerisée dans un cluster Kubernetes sécurisé et automatisé, pour **gagner du temps et éviter les erreurs**.

Je développe ce projet pour **aider les CTOs et startups tech** à :
- Mettre en ligne **rapidement** une API IA (FastAPI + modèle Hugging Face)
- Comprendre et maîtriser chaque brique Kubernetes (namespace, deployment, ingress…)
- Avoir une base **cloud-native, sécurisée, et automatisable** via CI/CD
- **Éviter les erreurs manuelles** grâce à une infra reproductible et documentée

En clair : **gagner du temps, réduire le stress opérationnel, et itérer proprement**.

## Ce que contient cette stack (v1.0.0)

- **Application IA FastAPI** – Exemple minimaliste : sentiment analysis via Hugging Face
- **Docker** – Containerisation propre et reproductible
- **Kubernetes local `k3d`** – Cluster local modulaire pour tout comprendre à la main
- **Manifests K8s écrits à la main** – Namespace, Deployment, Service, Ingress
- **CI/CD GitHub Actions** – Pipeline automatisé pour builder l’image et la pousser sur Docker Hub
- **RBAC, Secrets, NetworkPolicy** — Contrôle des accès et isolation réseau
- **Loki + Promtail + Grafana** — Centralisation et visualisation des logs K8s

## À qui ça s’adresse ?

1. **CTOs et startups tech** qui veulent :
	- Tester ou déployer une API IA sans galère infra
	- Avoir une base **Kubernetes claire, sécurisée et modulaire**
	- Monter en compétence sur la mise en prod cloud-native
	- Industrialiser rapidement un POC IA containerisé

2. **Freelances ou devs DevOps** qui veulent :
	- Un modèle concret pour **industrialiser un microservice IA**
	- Un point de départ pour étendre à un cluster cloud public

## Objectifs du projet (version originale)

A minimalist, modular Kubernetes stack that deploys an AI API with built-in security, observability, and automated CI/CD.

This project is both:
- a **public portfolio** for Kubernetes, GitOps and Cloud Security practices
- a **hands-on playground** to master K8s concepts step by step
- a **base stack** you can adapt for real-world freelance projects

### Quick Start

```bash
# Create your local cluster
k3d cluster create ai-bootstrap --port 80:80@loadbalancer

# Deploy app namespace & resources
kubectl apply -f k8s/base/

# Deploy observability stack
kubectl apply -f k8s/observability/

# Check status
kubectl get all -n ai-app
kubectl get all -n observability
````

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

➡️ See the [ROADMAP](ROADMAP.md) for upcoming features.

## Qui suis-je

Je m'appelle Bilal. 
J’aime bâtir des infrastructures **robustes, lisibles et sécurisées** — des fondations qui tiennent la route, et qui permettent d’itérer vite et bien.

Si vous voulez :
- Tester ce projet,
- L’adapter à votre POC IA,
- Ou automatiser et sécuriser vos propres déploiements cloud,

📬 **Écrivez-moi :**
## Me contacter

- 🔗 [Mon LinkedIn](https://www.linkedin.com/in/bilal-guirre-395544221/)
- 📧 bilal.guirre.pro@proton.me
