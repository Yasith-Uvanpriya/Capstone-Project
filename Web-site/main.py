from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from collections import Counter
import uvicorn

app = FastAPI()

# Enable CORS so Flutter can talk to this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace with Flutter domain in production
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/analyze")
async def analyze(request: Request):
    body = await request.json()
    data = body.get("data", [])

    # Simulated prediction logic: top 5 most common roads
    road_names = [item.get("location", "Unknown") for item in data]
    top_roads = [road for road, _ in Counter(road_names).most_common(5)]

    return {"top_roads": top_roads}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
