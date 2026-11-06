package io.github.vtinder.api.services;

import io.github.vtinder.api.models.Message;
import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.repositories.VTinderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.List;

import static io.github.vtinder.api.repositories.VTinderRepository.NotMatchedException;

@Component
public class ChatService {

    private static final int MAX_MESSAGE_LENGTH = 1000;

    private final VTinderRepository repository;

    @Autowired
    public ChatService(VTinderRepository repository) {
        this.repository = repository;
    }

    public List<Profile> getMatches(String userUuid) {
        return repository.getMatches(userUuid);
    }

    public List<Message> getMessages(String userUuid, String otherUuid, Long beforeId, Long afterId)
            throws NotMatchedException, InvalidMessageException {
        if (beforeId != null && afterId != null) {
            throw new InvalidMessageException("Specify at most one of beforeId and afterId");
        }
        return repository.getMessages(userUuid, otherUuid, beforeId, afterId);
    }

    public void sendMessage(String senderUuid, String receiverUuid, String text)
            throws NotMatchedException, InvalidMessageException {
        if (text == null || text.isBlank()) {
            throw new InvalidMessageException("Message cannot be empty");
        }
        if (text.length() > MAX_MESSAGE_LENGTH) {
            throw new InvalidMessageException("Message cannot be longer than " + MAX_MESSAGE_LENGTH + " characters");
        }
        repository.sendMessage(new Message(0, senderUuid, receiverUuid, Instant.now(), text, true));
    }

    public static class InvalidMessageException extends Exception {
        public InvalidMessageException(String msg) {super(msg);}
    }

}
