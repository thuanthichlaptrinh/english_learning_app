package com.thuanthichlaptrinh.card_words.entrypoint.rest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.ApiResponse;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping(path = "api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    @GetMapping("/hello")
    public ApiResponse<String> getMethodName() {
        return ApiResponse.success("success", "hello");
    }

}
