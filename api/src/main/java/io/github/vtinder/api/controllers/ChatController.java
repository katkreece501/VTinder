package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.services.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static io.github.vtinder.api.security.JwtAuthConfiguration.InvalidJwtException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.verifyIdentity;

@RestController
public class ChatController {

    private final ChatService chatService;

    @Autowired
    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/chat")
    public ResponseEntity<List<Profile>> getMatches(@RequestHeader("Authorization") String jwt)
            throws InvalidJwtException {
        String uuid = verifyIdentity(jwt);
        return ResponseEntity.ok(chatService.getMatches(uuid));
    }

}
