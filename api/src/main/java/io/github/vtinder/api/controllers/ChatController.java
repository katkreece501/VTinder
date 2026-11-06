package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Message;
import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.services.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static io.github.vtinder.api.repositories.VTinderRepository.NotMatchedException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.InvalidJwtException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.verifyIdentity;
import static io.github.vtinder.api.services.ChatService.InvalidMessageException;

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

    @GetMapping("/chat/{uuid}")
    public ResponseEntity<List<Message>> getMessages(
            @RequestHeader("Authorization") String jwt,
            @PathVariable("uuid") String otherUUID,
            @RequestParam(required = false) Long beforeId,
            @RequestParam(required = false) Long afterId)
            throws InvalidJwtException, NotMatchedException, InvalidMessageException {
        String userUUID = verifyIdentity(jwt);
        return ResponseEntity.ok(chatService.getMessages(userUUID, otherUUID, beforeId, afterId));
    }

    @PostMapping("/chat/{uuid}")
    public ResponseEntity<String> sendMessage(
            @RequestHeader("Authorization") String jwt,
            @PathVariable("uuid") String receiverUUID,
            @RequestBody String text)
            throws InvalidJwtException, NotMatchedException, InvalidMessageException {
        String senderUUID = verifyIdentity(jwt);
        chatService.sendMessage(senderUUID, receiverUUID, text);
        return ResponseEntity.ok("Success\n");
    }

}
