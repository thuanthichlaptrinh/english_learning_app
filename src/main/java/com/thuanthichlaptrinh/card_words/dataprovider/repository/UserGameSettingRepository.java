package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.core.domain.UserGameSetting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserGameSettingRepository extends JpaRepository<UserGameSetting, UUID> {

    Optional<UserGameSetting> findByUserId(UUID userId);

    void deleteByUserId(UUID userId);

}
