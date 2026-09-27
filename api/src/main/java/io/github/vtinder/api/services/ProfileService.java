package io.github.vtinder.api.services;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.repositories.ProfileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
public class ProfileService {

    private final ProfileRepository repository;

    @Autowired
    public ProfileService(ProfileRepository repository) {
        this.repository = repository;
    }

    public List<Profile> paginateProfiles() {
        return null;
    }

    public Optional<Profile> findProfileById(String uuid) {
        return repository.findProfileBy(uuid);
    }

    public List<Profile> getAllProfiles() {
        return repository.getAllProfiles();
    }

}
