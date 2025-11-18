# Environment Configuration

## ⚠️ IMPORTANT: Shared .env File

**Card Words AI now uses the SHARED `.env` file from the monorepo root.**

### File Location

```
project/server/.env  ← SHARED configuration file
```

### Why Shared?

-   ✅ Single source of truth for all services
-   ✅ No duplication of configs (JWT_SECRET, database credentials, etc.)
-   ✅ Easier to maintain and update
-   ✅ Consistent configuration across services

### How It Works

#### 1. Configuration Loading

The `config.py` file automatically reads from the root `.env`:

```python
class Settings(BaseSettings):
    class Config:
        # Points to root .env file
        env_file = str(Path(__file__).parent.parent.parent.parent / ".env")
```

#### 2. Environment Variables Used

All variables are defined in `project/server/.env`:

**Database:**

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=123456
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=card_words
```

**Redis:**

```env
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_AI_DB=1  # Different from Spring Boot (uses 0)
```

**JWT (Shared with Spring Boot):**

```env
JWT_SECRET=Y2FyZC13b3Jkcy1zZWNyZXQta2V5LWZvci1qd3QtdG9rZW4tZ2VuZXJhdGlvbg==
```

**AI Service Specific:**

```env
MODEL_PATH=/app/models/xgboost_model_v1.pkl
SCALER_PATH=/app/models/scaler_v1.pkl
MODEL_VERSION=v1.0.0
ADMIN_API_KEY=card-words-admin-key-2024
INTERNAL_API_KEY=card-words-internal-key-2024
CACHE_TTL=300
```

#### 3. URL Building

The config builds URLs automatically:

```python
# Database URL
settings.get_database_url
# Returns: postgresql://postgres:123456@postgres:5432/card_words

# Redis URL
settings.get_redis_url
# Returns: redis://redis:6379/1
```

### Local Development

#### Option 1: Using Docker (Recommended)

```bash
# The .env file is automatically used by docker-compose
docker-compose up -d card-words-ai
```

#### Option 2: Local Python

```bash
cd card-words-ai

# Install dependencies
poetry install

# Run (will auto-load ../../../.env)
poetry run uvicorn app.main:app --reload --port 8001
```

### Configuration Updates

To update any configuration:

1. **Edit the root .env file:**

    ```bash
    cd project/server
    nano .env  # or use any editor
    ```

2. **Restart the service:**
    ```bash
    docker-compose restart card-words-ai
    ```

### .env.example File

The `.env.example` in this directory is kept for **documentation purposes only**.

It shows:

-   What variables are used by this service
-   Expected values and formats
-   Comments and explanations

**Do NOT create a local `.env` file here.** All configs should be in the root `.env`.

### Environment Variables Priority

1. **Environment variables** (highest priority)
2. **Root .env file** (`project/server/.env`)
3. **Default values** in `config.py` (lowest priority)

### Verification

Check if config is loaded correctly:

```bash
# Start the service
docker-compose up -d card-words-ai

# Check logs
docker-compose logs card-words-ai | grep "initialized"

# Expected output:
# database_service_initialized database_url=postgres:5432/card_words
# cache_service_initialized redis_url=redis://redis:6379/1
```

### Troubleshooting

#### Config not loading?

```bash
# Check if .env exists
ls -la ../../.env

# Check Docker Compose passes variables
docker-compose config | grep -A 20 card-words-ai
```

#### Wrong database/redis connection?

```bash
# Verify inside container
docker exec -it card-words-ai python -c "from app.config import settings; print(settings.get_database_url); print(settings.get_redis_url)"
```

#### Need different config for local dev?

```bash
# Override with environment variables
export DATABASE_URL="postgresql://localhost:5433/card_words"
poetry run uvicorn app.main:app --reload
```

### Migration from Old Setup

If you previously had a local `.env` file:

1. **Backup your local .env (if exists):**

    ```bash
    mv .env .env.backup
    ```

2. **Use root .env:**
   All configs are now in `../../.env`

3. **No changes needed to code:**
   The `config.py` now automatically points to the root file

### Summary

| File           | Purpose                                            |
| -------------- | -------------------------------------------------- |
| `../../.env`   | ✅ **ACTUAL configuration** (used by all services) |
| `.env.example` | 📚 Documentation only (reference)                  |
| `.env` (local) | ❌ **Do NOT create** (will be ignored)             |

For more information, see:

-   Root README: `../../README.md`
-   Docker setup: `../../docs/docker/DOCKER_SETUP.md`
-   Full AI docs: `../../docs/AI/CARD_WORDS_AI_OVERVIEW.md`
