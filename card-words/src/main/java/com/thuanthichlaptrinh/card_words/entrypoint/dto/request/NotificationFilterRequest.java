package com.thuanthichlaptrinh.card_words.entrypoint.dto.request;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NotificationFilterRequest {

    private Boolean isRead;

    @Size(max = 50)
    private String type;

    @Builder.Default
    private Integer page = 0;

    @Builder.Default
    private Integer size = 10;
}
