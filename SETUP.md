# Card Words - English Learning Application

## 🚀 Setup Instructions

### Prerequisites

-   Java 17 or higher
-   PostgreSQL 15+
-   Maven 3.8+

### Environment Configuration

1. **Copy environment file:**

    ```bash
    cp .env.example .env
    ```

2. **Fill in your actual values in `.env`:**

    ```bash
    # Database
    POSTGRES_DB=card_words_db
    POSTGRES_USER=your_username
    POSTGRES_PASSWORD=your_password

    # JWT
    JWT_SECRET=your-256-bit-secret-key

    # Google OAuth (get from Google Console)
    GOOGLE_OAUTH_CLIENT_ID=your-google-client-id
    GOOGLE_OAUTH_CLIENT_SECRET=your-google-client-secret
    ```

### Google OAuth Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URIs:
    - `http://localhost:8080/api/v1/auth/google/callback`
6. Copy Client ID and Client Secret to your `.env` file

### Running the Application

```bash
# Install dependencies
./mvnw clean install

# Run the application
./mvnw spring-boot:run
```

### API Documentation

-   Swagger UI: http://localhost:8080/swagger-ui.html
-   API Docs: http://localhost:8080/v3/api-docs

## 🔐 Security Notes

-   **Never commit** `.env` files or files containing secrets
-   Use environment variables for all sensitive configuration
-   Rotate secrets regularly in production
