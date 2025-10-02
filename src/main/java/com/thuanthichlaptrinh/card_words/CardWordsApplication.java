package com.thuanthichlaptrinh.card_words;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class CardWordsApplication {
	public static void main(String[] args) {
		SpringApplication.run(CardWordsApplication.class, args);
	}
}
