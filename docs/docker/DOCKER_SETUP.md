# 🐳 Docker Setup Guide - AI Chatbot

## Quick Start

### 1. Setup Environment

**Windows:**

```bash
# Copy .env.example to .env
copy .env.example .env

# Edit .env and add your Gemini API Key
notepad .env
```

**Linux/Mac:**

```bash
cp .env.example .env
nano .env  # or vim .env
```

### 2. Update GEMINI_API_KEY in .env

```env
GEMINI_API_KEY=
```

### 3. Build & Run with Docker Compose

```bash
# Build images
docker-compose build

# Start all services
docker-compose up -d

# Check logs
docker-compose logs -f app
```

### 4. Verify Services

-   **Application**: http://localhost:8080
-   **Swagger UI**: http://localhost:8080/swagger-ui.html
-   **PgAdmin**: http://localhost:5050
-   **Redis Insight**: http://localhost:5540

### 5. Test Chatbot API

```bash
# 1. Login to get JWT token
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "your-email@example.com",
    "password": "your-password"
  }'

# 2. Chat with AI (replace {token} with your JWT)
curl -X POST http://localhost:8080/api/v1/chatbot/chat \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Làm sao để học từ vựng hiệu quả?",
    "includeContext": true,
    "searchFaq": true
  }'
```

## Docker Commands

### Rebuild after code changes

```bash
# Stop containers
docker-compose down

# Rebuild app service
docker-compose build app

# Start again
docker-compose up -d

# Or do all in one command
docker-compose up -d --build app
```

### View logs

```bash
# All services
docker-compose logs -f

# App only
docker-compose logs -f app

# Last 100 lines
docker-compose logs --tail=100 app
```

### Database operations

```bash
# Access PostgreSQL container
docker exec -it card-words-postgres psql -U postgres -d card_words

# Run migrations manually (if needed)
docker exec -it card-words-app java -jar app.jar --spring.flyway.enabled=true

# Backup database
docker exec card-words-postgres pg_dump -U postgres card_words > backup.sql

# Restore database
docker exec -i card-words-postgres psql -U postgres card_words < backup.sql
```

### Cleanup

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: deletes all data)
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

## Troubleshooting

### Error: "Cannot connect to Gemini API"

Check:

1. GEMINI_API_KEY is set correctly in `.env`
2. Container has internet access
3. API key is valid: https://makersuite.google.com/app/apikey

```bash
# Check environment variables in container
docker exec card-words-app env | grep GEMINI
```

### Error: "Port already in use"

Change ports in `docker-compose.yml`:

```yaml
app:
    ports:
        - '8081:8080' # Use 8081 instead of 8080
```

### Error: "Database migration failed"

```bash
# Check Flyway migration status
docker exec -it card-words-app java -jar app.jar --spring.flyway.info=true

# Force repair if needed
docker exec -it card-words-app java -jar app.jar --spring.flyway.repair=true
```

### Container keeps restarting

```bash
# Check logs
docker logs card-words-app

# Check health
docker inspect card-words-app | grep -A 10 Health
```

### Cannot build Maven dependencies

Clear Maven cache and rebuild:

```bash
docker-compose build --no-cache app
```

## Production Deployment

### 1. Use docker-compose.shared-db.yml

For production with external database:

```bash
# Copy .env.shared-db-example to .env
cp .env.shared-db-example .env

# Update database credentials
nano .env

# Run with shared DB config
docker-compose -f docker-compose.shared-db.yml up -d
```

### 2. Secure API Key

Never commit `.env` to git. Use Docker secrets or environment variables in production.

### 3. Enable HTTPS

Use reverse proxy (Nginx/Traefik) with SSL certificates.

### 4. Resource Limits

Add to `docker-compose.yml`:

```yaml
app:
    deploy:
        resources:
            limits:
                cpus: '2'
                memory: 2G
            reservations:
                cpus: '1'
                memory: 1G
```

## Architecture

```
┌─────────────────────────────────────────┐
│         Docker Network                  │
│  ┌──────────┐  ┌──────────┐            │
│  │          │  │          │            │
│  │ Postgres │  │  Redis   │            │
│  │          │  │          │            │
│  └────▲─────┘  └────▲─────┘            │
│       │             │                   │
│       │             │                   │
│  ┌────┴─────────────┴─────┐            │
│  │                         │            │
│  │   Spring Boot App       │            │
│  │   + Gemini AI           │            │
│  │                         │            │
│  └─────────────────────────┘            │
│              │                          │
└──────────────┼──────────────────────────┘
               │
          Port 8080
               ▼
         Your Browser
```

## Next Steps

1. ✅ Test API endpoints via Swagger
2. ✅ Configure production database
3. ✅ Setup monitoring (Prometheus/Grafana)
4. ✅ Add rate limiting
5. ✅ Setup CI/CD pipeline

---

**Status**: ✅ Ready for Docker deployment  
**Model**: gemini-2.5-flash-exp  
**Cost**: FREE
