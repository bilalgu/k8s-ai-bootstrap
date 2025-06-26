from fastapi import FastAPI,HTTPException
from pydantic import BaseModel
from transformers import pipeline

app = FastAPI()
classifier = pipeline("sentiment-analysis")

class TextInput(BaseModel):
    text: str

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/predict")
def predict(input: TextInput):
    try:
        result = classifier(input.text)[0]
        return {"label": result["label"], "score": result["score"]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
