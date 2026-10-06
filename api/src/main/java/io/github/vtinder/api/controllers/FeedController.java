package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Dislike;
import io.github.vtinder.api.models.Like;
import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.services.FeedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import static io.github.vtinder.api.services.FeedService.FeedActionUnsuccessfulException;

import java.util.List;

@RestController
public class FeedController {

    private final FeedService feedService;

    @Autowired
    public FeedController(FeedService feedService) {this.feedService = feedService;}

    // Like user endpoint
    @PostMapping("/feed/like/{likerUuid}/{likedUuid}")
    public ResponseEntity<String> likeProfile(@PathVariable String likerUuid, @PathVariable String likedUuid)
            throws FeedActionUnsuccessfulException {
        feedService.like(new Like(likerUuid, likedUuid));
        return ResponseEntity.ok("Success\n");
    }

    // Dislike user endpoint
    @PostMapping("/feed/dislike/{dislikerUuid}/{dislikedUuid}")
    public ResponseEntity<String> dislikeProfile(@PathVariable String dislikerUuid, @PathVariable String dislikedUuid)
            throws FeedActionUnsuccessfulException {
        feedService.dislike(new Dislike(dislikerUuid, dislikedUuid));
        return ResponseEntity.ok("Success\n");
    }

    // Get profiles available to user endpoint
    @GetMapping("/feed/{uuid}")
    public ResponseEntity<List<Profile>> getFeed(@PathVariable String uuid) {
        return ResponseEntity.ok(feedService.getFeed(uuid));
    }

}
