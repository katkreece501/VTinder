package io.github.vtinder.api.repositories;

import io.github.vtinder.api.models.Profile;
import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
public class ProfileRepository {

    private final Jdbi jdbi;

    @Autowired
    public ProfileRepository(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    public Optional<Profile> findProfileBy(String uuid) {
        return null;
    }

    public List<Profile> getAllProfiles() {
        return jdbi.withHandle(handle ->
                handle.createQuery(
                        "SELECT p.*, u.name FROM profiles p JOIN users u"
                        +   " ON p.user_uuid = u.uuid")
                        .mapTo(Profile.class).list()
        );
    }

}
