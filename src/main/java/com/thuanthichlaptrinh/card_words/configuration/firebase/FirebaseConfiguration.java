package com.thuanthichlaptrinh.card_words.configuration.firebase;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Bucket;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.StorageClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.io.InputStream;

@Slf4j
@Configuration
public class FirebaseConfiguration {

    @Value("${firebase.storage.bucket-name}")
    private String bucketName;

    @Value("${firebase.storage.service-account-path}")
    private String serviceAccountPath;

    @Bean
    public FirebaseApp initializeFirebase() throws IOException {
        if (!FirebaseApp.getApps().isEmpty()) {
            log.info("Firebase app already initialized, returning existing instance");
            return FirebaseApp.getInstance();
        }

        log.info("Initializing Firebase with bucket: {}", bucketName);

        Resource resource = new ClassPathResource("firebase-service-account.json");

        try (InputStream serviceAccount = resource.getInputStream()) {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .setStorageBucket(bucketName)
                    .build();

            FirebaseApp app = FirebaseApp.initializeApp(options);
            log.info("Firebase initialized successfully");
            return app;
        } catch (IOException e) {
            log.error("Failed to initialize Firebase: {}", e.getMessage());
            throw e;
        }
    }

    @Bean
    public Bucket firebaseBucket() throws IOException {
        initializeFirebase();
        String[] candidates = new String[] { bucketName, bucketName + ".appspot.com",
                bucketName.replace(".firebasestorage.app", ".appspot.com") };

        for (String candidate : candidates) {
            if (candidate == null || candidate.isBlank())
                continue;
            try {
                Bucket b = StorageClient.getInstance().bucket(candidate);
                if (b != null) {
                    log.info("Resolved Firebase bucket using candidate: {}", candidate);
                    return b;
                }
            } catch (Exception ex) {
                log.warn("Bucket candidate '{}' not found or not accessible: {}", candidate, ex.getMessage());
            }
        }

        try {
            Bucket defaultBucket = StorageClient.getInstance().bucket();
            if (defaultBucket != null) {
                log.info("Using default Firebase bucket from StorageClient: {}", defaultBucket.getName());
                return defaultBucket;
            }
        } catch (Exception ex) {
            log.error("Failed to get default Firebase bucket: {}", ex.getMessage());
        }

        log.error("No Firebase bucket could be resolved. Upload endpoints will fail until configuration is fixed.");
        return null;
    }
}
