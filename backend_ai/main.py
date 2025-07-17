from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from collections import Counter
import uvicorn

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow Flutter Web to access API
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/analyze")
async def analyze(request: Request):
    body = await request.json()
    data = body.get("data", [])

    road_names = [item.get("location", "Unknown") for item in data]
    top_roads = [road for road, _ in Counter(road_names).most_common(5)]

    return {"top_roads": top_roads}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)