# Step 1 - AI API with FastAPI + Hugging Face

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

> *Return a negative sentiment.*