"""
Card Words AI Service - Main Application
FastAPI application for ML-powered vocabulary review recommendations
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime

# Create FastAPI app
app = FastAPI(
    title="Card Words AI Service",
    description="AI-powered vocabulary review recommendations using LightGBM",
    version="0.1.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "service": "Card Words AI",
        "version": "0.1.0",
        "status": "running",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "card-words-ai",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/api/v1/info")
async def get_info():
    """Get service information"""
    return {
        "service": "Card Words AI",
        "version": "0.1.0",
        "description": "ML-powered vocabulary review recommendations",
        "features": [
            "Smart vocabulary review",
            "LightGBM predictions",
            "Personalized learning paths"
        ]
    }

# Placeholder for future ML endpoints
@app.get("/api/v1/review/smart")
async def get_smart_review(user_id: str, limit: int = 20):
    """
    Get smart vocabulary review recommendations
    
    TODO: Implement ML prediction logic
    """
    return {
        "user_id": user_id,
        "limit": limit,
        "vocabs": [],
        "meta": {
            "message": "ML model not yet implemented",
            "status": "placeholder"
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
