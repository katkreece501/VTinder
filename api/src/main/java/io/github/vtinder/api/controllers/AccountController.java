package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.models.Registration;
import io.github.vtinder.api.models.User;
import io.github.vtinder.api.services.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

import static io.github.vtinder.api.services.AccountService.RegistrationFailedException;
import static io.github.vtinder.api.services.AccountService.NoSuchEntityException;

// TODO handle checked exceptions
@RestController
public class AccountController {

    private final AccountService accountService;

    @Autowired
    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }

    @GetMapping("/accounts/{uuid}")
    public ResponseEntity<User> getUser(@PathVariable String uuid) throws NoSuchEntityException {
        return ResponseEntity.of(Optional.of(accountService.getUser(uuid)));
    }

    // Create account user
    @PostMapping("/accounts")
    public ResponseEntity<String> registerUser(@RequestBody Registration req) throws RegistrationFailedException {
        accountService.registerUser(req);
        return ResponseEntity.ok("Success\n");
    }

    // Fetch specific profile
    @GetMapping("/profiles/{uuid}")
    public ResponseEntity<Profile> getProfile(@PathVariable String uuid) throws NoSuchEntityException {
        return ResponseEntity.of(Optional.of(accountService.getProfile(uuid)));
    }

    // Edit profile endpoint
    @PutMapping("/profiles")
    public ResponseEntity<String> editProfile(RequestEntity<Profile> profile) throws NoSuchEntityException {
        accountService.editProfile(profile.getBody());
        return ResponseEntity.ok("Success\n");
    }

}
