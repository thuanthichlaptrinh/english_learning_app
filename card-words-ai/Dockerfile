# Multi-stage build for Python AI Service
FROM python:3.11-slim as base

# Set working directory
WORKDIR /app

# Install system dependencies and update pip
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libgomp1 \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy dependency files
COPY requirements.txt ./

# Install Python dependencies with increased timeout
ENV PIP_DEFAULT_TIMEOUT=300
RUN pip install --no-cache-dir --timeout=300 -r requirements.txt

# Copy application code
COPY app/ ./app/

# Create models directory (will be mounted as volume)
RUN mkdir -p ./models

# Create non-root user for security
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001"]
