package com.thuanthichlaptrinh.card_words.core.mapper;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserAdminResponse;

@Component
public class UserAdminMapper {

    public UserAdminResponse toUserAdminResponse(User user) {
        if (user == null) {
            return null;
        }

        UserAdminResponse response = new UserAdminResponse();
        response.setId(user.getId());
        response.setEmail(user.getEmail());
        response.setName(user.getName());
        response.setAvatar(user.getAvatar());
        response.setGender(user.getGender());
        response.setDateOfBirth(user.getDateOfBirth());
        response.setCurrentLevel(user.getCurrentLevel());
        response.setActivated(user.getActivated());
        response.setBanned(user.getBanned());
        response.setStatus(user.getStatus());
        response.setCreatedAt(user.getCreatedAt());
        response.setUpdatedAt(user.getUpdatedAt());

        // Map roles to list of role names
        if (user.getRoles() != null) {
            List<String> roleNames = user.getRoles().stream()
                    .map(Role::getName)
                    .collect(Collectors.toList());
            response.setRoles(roleNames);
        }

        return response;
    }
}
