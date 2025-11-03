package com.thuanthichlaptrinh.card_words.entrypoint.dto.request.vocab;

import java.util.Set;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateVocabRequest {

    @NotBlank(message = "Từ vựng không được để trống")
    @Size(min = 1, max = 100, message = "Từ vựng phải từ 1-100 ký tự")
    private String word;

    @Size(max = 100, message = "Phiên âm tối đa 100 ký tự")
    private String transcription;

    @NotBlank(message = "Nghĩa tiếng Việt không được để trống")
    @Size(max = 500, message = "Nghĩa tiếng Việt tối đa 500 ký tự")
    private String meaningVi;

    @Size(max = 1000, message = "Giải thích tối đa 1000 ký tự")
    private String interpret;

    @Size(max = 1000, message = "Câu ví dụ tối đa 1000 ký tự")
    private String exampleSentence;

    @Pattern(regexp = "^(A1|A2|B1|B2|C1|C2)$", message = "CEFR level phải là một trong: A1, A2, B1, B2, C1, C2")
    private String cefr;

    @Size(max = 500, message = "URL hình ảnh tối đa 500 ký tự")
    private String img;

    @Size(max = 500, message = "URL audio tối đa 500 ký tự")
    private String audio;

    @Size(max = 255, message = "Ghi công tối đa 255 ký tự")
    private String credit;

    private Set<String> types;
    private Set<String> topics;

}