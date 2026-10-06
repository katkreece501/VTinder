package io.github.vtinder.api.services;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.models.Registration;
import io.github.vtinder.api.models.User;
import io.github.vtinder.api.repositories.VTinderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class AccountService {

    private final VTinderRepository repository;

    @Autowired
    public AccountService(VTinderRepository repository) {
        this.repository = repository;
    }

    public void registerUser(Registration registration) throws RegistrationFailedException {
        int rowsEdited = repository.registerUser(
            new User(registration.getUuid(),
                registration.getName(),
                registration.getEmail(),
                false),
                registration.getPassword()
        );
        if (rowsEdited == 0) {
            throw new RegistrationFailedException();
        }
    }

    public User getUser(String uuid) throws NoSuchEntityException {
        return repository.findUserByUuid(uuid)
                .orElseThrow(() -> new NoSuchEntityException("No user with uuid " + uuid));
    }

    public Profile getProfile(String uuid) throws NoSuchEntityException {
        return repository.findProfileByUuid(uuid)
                .orElseThrow(() -> new NoSuchEntityException("No profile with uuid " + uuid));
    }

    public void editProfile(Profile profile) throws NoSuchEntityException {
        int rowsEdited = repository.editProfile(profile);
        if (rowsEdited == 0) throw new NoSuchEntityException("No profile with uuid " + profile.getUuid());
    }

    public List<Profile> getAllProfiles() {
        return repository.getAllProfiles();
    }

    public static class NoSuchEntityException extends Exception {
        public NoSuchEntityException(String msg) {super(msg);}
    }
    public static class RegistrationFailedException extends Exception {}

}
