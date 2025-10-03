package com.thuanthichlaptrinh.card_words.entrypoint.rest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/api/v1/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "API quản lý người dùng")
public class UserController {

}
