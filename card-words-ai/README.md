# Card Words AI Service

AI-powered vocabulary review system using LightGBM for smart recommendations.

## Features

- Smart vocabulary review recommendations
- LightGBM-based predictions
- Personalized learning paths
- Real-time ML inference

## Tech Stack

- **Framework:** FastAPI
- **ML:** LightGBM, scikit-learn
- **Database:** PostgreSQL (read-only)
- **Cache:** Redis
- **Python:** 3.11+

## Development

```bash
# Install dependencies
poetry install

# Run locally
poetry run uvicorn app.main:app --reload --port 8001

# Run tests
poetry run pytest
```

## Docker

```bash
# Build
docker-compose build card-words-ai

# Run
docker-compose up -d card-words-ai

# Logs
docker-compose logs -f card-words-ai
```

## API Endpoints

- `GET /` - Root endpoint
- `GET /health` - Health check
- `GET /api/v1/info` - Service information
- `GET /api/v1/review/smart` - Smart review recommendations (TODO)

## Models

Place trained models in `models/` directory:
- `lightgbm_vocab_predictor.txt`
- `feature_names.json`

## Environment Variables

See `.env` file for configuration.
