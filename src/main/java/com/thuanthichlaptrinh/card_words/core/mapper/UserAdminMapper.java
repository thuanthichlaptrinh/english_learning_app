package com.thuanthichlaptrinh.card_words.core.mapper;

import java.util.List;
import java.util.Set;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;

import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.UserAdminResponse;

@Mapper(componentModel = "spring")
public interface UserAdminMapper {

    UserAdminMapper INSTANCE = Mappers.getMapper(UserAdminMapper.class);

    @Mapping(target = "roles", source = "roles", qualifiedByName = "mapRolesToNames")
    UserAdminResponse toUserAdminResponse(User user);

    @Named("mapRolesToNames")
    default List<String> mapRolesToNames(Set<Role> roles) {
        if (roles == null) {
            return List.of();
        }
        return roles.stream()
                .map(Role::getName)
                .toList();
    }
}
