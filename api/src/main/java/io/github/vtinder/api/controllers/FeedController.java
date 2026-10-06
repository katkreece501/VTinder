package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.services.FeedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController("/feed")
public class FeedController {

    private FeedService feedService;

    @Autowired
    public FeedController(FeedService feedService) {
        this.feedService = feedService;
    }

    @GetMapping
    public List<Profile> getAllProfiles() {
        return null;
    }

    // Like user endpoint
    @PostMapping("/like/{userId}")
    public Boolean likeProfile() {
        return null;
    }

    // Dislike user endpoint
    @PostMapping("/dislike/{userId}")
    public Boolean dislikeProfile() {
        return null;
    }

    // Get profiles available to user endpoint
    @GetMapping("/feed/{userId}")
    public List<Profile> getFeed() {
        return null;
    }

}
