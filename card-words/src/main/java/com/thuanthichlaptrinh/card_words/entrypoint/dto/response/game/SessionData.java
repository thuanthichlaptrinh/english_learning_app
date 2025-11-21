package com.thuanthichlaptrinh.card_words.entrypoint.dto.response.game;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

import com.thuanthichlaptrinh.card_words.core.domain.Vocab;

@Getter
@Setter
@AllArgsConstructor
public class SessionData {
    private final UUID sessionId;
    private final List<Vocab> vocabs;
}
