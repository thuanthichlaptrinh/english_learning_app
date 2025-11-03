package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user;

import java.util.List;

import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateRolesRequest {
    @NotEmpty(message = "Danh sách role không được rỗng")
    private List<String> roleNames;
}
