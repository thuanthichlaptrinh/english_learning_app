# Docker Setup Guide - Card Words Services

## 📋 Quick Start

### 1. Prerequisites

- Docker Desktop installed
- Docker Compose v2.0+
- Git

### 2. Setup Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your actual values
nano .env  # or use your favorite editor
```

**Important variables to change:**
- `POSTGRES_PASSWORD` - Strong database password
- `JWT_SECRET` - Generate with: `openssl rand -base64 32`
- `MAIL_USERNAME` & `MAIL_PASSWORD` - Your Gmail credentials
- `GOOGLE_OAUTH_CLIENT_ID` & `GOOGLE_OAUTH_CLIENT_SECRET` - Your OAuth credentials

### 3. Build and Run

```bash
# Build all services
docker-compose build

# Start all services (development)
docker-compose up -d

# Or start with development overrides
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# View logs
docker-compose logs -f
```

### 4. Verify Services

```bash
# Check status
docker-compose ps

# Test Spring Boot API
curl http://localhost:8080/actuator/health

# Test Python AI Service
curl http://localhost:8001/health

# Test PostgreSQL
docker-compose exec postgres pg_isready -U postgres

# Test Redis
docker-compose exec redis redis-cli ping
```

---

## 🏗️ Project Structure

```
card-words-services/
├── docker-compose.yml              # Main orchestration
├── docker-compose.dev.yml          # Development overrides
├── docker-compose.prod.yml         # Production overrides
├── .env                            # Environment variables (gitignored)
├── .env.example                    # Environment template
│
├── card-words/                     # Spring Boot Backend
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── .dockerignore
│
└── card-words-ai/                  # Python AI Service
    ├── app/
    ├── models/
    ├── pyproject.toml
    ├── Dockerfile
    └── .dockerignore
```

---

## 🚀 Common Commands

### Development

```bash
# Start all services
docker-compose up -d

# Start with hot reload
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Stop all services
docker-compose down

# Rebuild specific service
docker-compose up -d --build card-words-ai

# View logs
docker-compose logs -f card-words-api
docker-compose logs -f card-words-ai

# Execute command in container
docker-compose exec card-words-api bash
docker-compose exec card-words-ai bash
```

### Database Management

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U postgres -d card_words

# Backup database
docker-compose exec postgres pg_dump -U postgres card_words > backup.sql

# Restore database
docker-compose exec -T postgres psql -U postgres card_words < backup.sql

# Access PgAdmin
# Open: http://localhost:5050
# Login: admin@cardwords.com / admin123
```

### Redis Management

```bash
# Connect to Redis CLI
docker-compose exec redis redis-cli

# Access Redis Insight
# Open: http://localhost:5540
```

---

## 🔧 Service URLs

| Service | URL | Description |
|---------|-----|-------------|
| **Spring Boot API** | http://localhost:8080 | Main backend API |
| **Python AI Service** | http://localhost:8001 | ML prediction service |
| **PgAdmin** | http://localhost:5050 | PostgreSQL GUI |
| **Redis Insight** | http://localhost:5540 | Redis GUI |
| **Swagger UI** | http://localhost:8080/swagger-ui.html | API documentation |

---

## 🐛 Troubleshooting

### Port Already in Use

```bash
# Check what's using the port
netstat -ano | findstr :8080  # Windows
lsof -i :8080                 # Linux/Mac

# Change port in docker-compose.yml
ports:
  - '8081:8080'  # Use different external port
```

### Container Won't Start

```bash
# Check logs
docker-compose logs card-words-api

# Restart container
docker-compose restart card-words-api

# Remove and recreate
docker-compose rm -f card-words-api
docker-compose up -d card-words-api
```

### Database Connection Failed

```bash
# Check if postgres is healthy
docker-compose ps postgres

# Check postgres logs
docker-compose logs postgres

# Test connection
docker-compose exec postgres psql -U postgres -c "SELECT 1;"
```

### Out of Memory

```bash
# Check Docker resources
docker stats

# Increase Docker memory limit
# Docker Desktop → Settings → Resources → Memory

# Or add to docker-compose.yml
services:
  card-words-api:
    mem_limit: 2g
```

---

## 🌍 Production Deployment

### 1. Update Environment

```bash
# Create production .env
cp .env.example .env.prod

# Edit with production values
nano .env.prod
```

### 2. Deploy

```bash
# Build for production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build

# Start services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.yml -f docker-compose.prod.yml ps
```

### 3. Monitor

```bash
# View logs
docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f

# Check resource usage
docker stats
```

---

## 🧹 Cleanup

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (⚠️ deletes data)
docker-compose down -v

# Remove all images
docker-compose down --rmi all

# Clean up system
docker system prune -a
```

---

## 📝 Notes

### card-words-ai Models

The `card-words-ai/models/` directory is mounted as a volume. Place your trained models here:

```bash
card-words-ai/models/
├── lightgbm_vocab_predictor.txt
└── feature_names.json
```

Models can be updated without rebuilding the container.

### Hot Reload

Development mode enables hot reload:
- **Spring Boot**: Requires spring-boot-devtools
- **Python AI**: Automatically enabled with `--reload` flag

### Environment Variables

All services share the same `.env` file for consistency. Service-specific variables are prefixed:
- Spring Boot: No prefix
- Python AI: `AI_` prefix (optional)

---

## 🆘 Support

If you encounter issues:

1. Check logs: `docker-compose logs -f`
2. Verify environment: `docker-compose config`
3. Check health: `docker-compose ps`
4. Restart services: `docker-compose restart`

---

**Last Updated:** 2024-11-16  
**Version:** 1.0
