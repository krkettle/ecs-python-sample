from fastapi import FastAPI
from typing import Any, Dict
import json
import boto3

app = FastAPI()


@app.get("/")
async def root() -> Dict[str, str]:
    return {"message": "Hello World"}


@app.get("/s3")
async def s3_timestamp() -> Any:
    clinet = boto3.client("s3")
    BUCKET_NAME = "docker-python-sample-bucket"
    OBJECT_KEY = "sample.json"
    res = clinet.get_object(Bucket=BUCKET_NAME, Key=OBJECT_KEY)
    body = res["Body"].read()
    return json.loads(body.decode("utf-8"))
