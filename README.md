# k8s-ai-bootstrap

Build a secure, modular Kubernetes stack to deploy AI applications with CI/CD, observability, and security.

## Step 1 - AI API with FastAPI + Hugging Face

**Objective:**

Build and containerize a minimal REST API for sentiment analysis using Hugging Face Transformers.

**Stack:**

- [FastAPI](https://fastapi.tiangolo.com/)
- [Hugging Face Transformers](https://huggingface.co/)
- [Docker](https://www.docker.com/)

**File structure:**

```
.
├── app/
│   ├── Dockerfile
│   ├── main.py
│   └── requirements.txt
```

**Deployment:**

```bash
cd app/
docker build -t ai-api:v1 .
docker run -p 8000:8000 ai-api:v1
````

**Validation:**

```bash
curl -X 'POST' 'http://127.0.0.1:8000/predict' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"text": "I love eggs and life!"}'
```

> *This should return a positive response → the model detects a positive sentiment.*

```bash
curl -X 'POST' 'http://127.0.0.1:8000/predict' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"text": "I hate Coca-Cola and chips!"}'
```

> *negative sentiment.*

## Step 2 - Deploy to Kubernetes (with k3d)

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
│       ├── namespace.yaml
│       └── service.yaml
```

**Deployment:**

```bash
k3d cluster create ai-bootstrap
kubectl apply -f k8s/base/namespace.yaml
kubectl apply -f k8s/base/deployment.yaml
kubectl apply -f k8s/base/service.yaml
````

**Validation:**

1. Wait for the pod to reach the "Running" status:

```bash
kubectl get pods -n ai-app
```

2. Port-forward the pod:

```bash
kubectl port-forward <pod-name> -n ai-app 8000:8000
```

3. Send test requests:

```bash
curl -X 'POST' 'http://127.0.0.1:8000/predict' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"text": "I love meat and sports!"}'
```
