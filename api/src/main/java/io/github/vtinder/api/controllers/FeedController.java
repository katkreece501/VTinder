package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Dislike;
import io.github.vtinder.api.models.Like;
import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.services.FeedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static io.github.vtinder.api.security.JwtAuthConfiguration.InvalidJwtException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.verifyIdentity;
import static io.github.vtinder.api.services.FeedService.FeedActionUnsuccessfulException;

import java.util.List;

@RestController
public class FeedController {

    private final FeedService feedService;

    @Autowired
    public FeedController(FeedService feedService) {this.feedService = feedService;}

    // Like user endpoint
    @PostMapping("/feed/like/{likerUuid}/{likedUuid}")
    public ResponseEntity<String> likeProfile(@RequestHeader("Authorization") String jwt, @PathVariable String likedUuid)
            throws FeedActionUnsuccessfulException, InvalidJwtException {
        String userUUID = verifyIdentity(jwt);
        feedService.like(new Like(userUUID, likedUuid));
        return ResponseEntity.ok("Success\n");
    }

    // Dislike user endpoint
    @PostMapping("/feed/dislike/{dislikerUuid}/{dislikedUuid}")
    public ResponseEntity<String> dislikeProfile(@RequestHeader("Authorization") String jwt, @PathVariable String dislikedUuid)
            throws FeedActionUnsuccessfulException, InvalidJwtException {
        String userUUID = verifyIdentity(jwt);
        feedService.dislike(new Dislike(userUUID, dislikedUuid));
        return ResponseEntity.ok("Success\n");
    }

    // Get profiles available to user endpoint
    @GetMapping("/feed/{uuid}")
    public ResponseEntity<List<Profile>> getFeed(@RequestHeader("Authorization") String jwt)
            throws InvalidJwtException {
        String uuid = verifyIdentity(jwt);
        return ResponseEntity.ok(feedService.getFeed(uuid));
    }

}
