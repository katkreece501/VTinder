package io.github.vtinder.api.services;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.models.User;
import io.github.vtinder.api.repositories.VTinderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ChatService {

    private final VTinderRepository repository;

    @Autowired
    public ChatService(VTinderRepository repository) {
        this.repository = repository;
    }

    public List<Profile> getMatches(String userUuid) {
        return repository.getMatches(userUuid);
    }

}
