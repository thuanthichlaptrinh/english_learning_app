package com.thuanthichlaptrinh.card_words.dataprovider.repository;

import com.thuanthichlaptrinh.card_words.common.enums.GameName;
import com.thuanthichlaptrinh.card_words.core.domain.UserGameSetting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserGameSettingRepository extends JpaRepository<UserGameSetting, UUID> {

    Optional<UserGameSetting> findByUserIdAndGameName(UUID userId, GameName gameName);

    List<UserGameSetting> findByUserId(UUID userId);

    boolean existsByUserIdAndGameName(UUID userId, GameName gameName);

    void deleteByUserId(UUID userId);

    void deleteByUserIdAndGameName(UUID userId, GameName gameName);

}

