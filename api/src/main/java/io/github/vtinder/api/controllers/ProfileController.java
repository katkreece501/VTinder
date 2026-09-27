package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.services.ProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ProfileController {

    private ProfileService profileService;

    @Autowired
    public ProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    // Receive image via a Swift "Data" type
//    @PostMapping("/profile")
//    public void createProfile() {
//
//    }

    @GetMapping("/profiles")
    public List<Profile> getAllProfiles() {
        return profileService.getAllProfiles();
    }


//    @GetMapping("/profiles/{page}")
//    public List<Profile> paginateProfiles(@PathVariable("page") Integer page) {
//        return null;
//    }



}
