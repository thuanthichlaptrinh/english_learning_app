# Dockerfile for Spring Boot API - Railway deployment
# Stage 1: Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies (cached layer)
COPY card-words/pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY card-words/src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Railway will auto-detect)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run application with memory optimization
ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-XX:+UseG1GC", "-jar", "-Dspring.profiles.active=prod", "app.jar"]
