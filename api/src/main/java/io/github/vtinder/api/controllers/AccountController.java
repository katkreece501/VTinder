package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.models.User;
import io.github.vtinder.api.services.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static io.github.vtinder.api.security.JwtAuthConfiguration.InvalidJwtException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.verifyIdentity;
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
    public ResponseEntity<User> getUser(@RequestHeader("Authorization") String jwt) throws NoSuchEntityException, InvalidJwtException {
        String userUUID = verifyIdentity(jwt);
        return ResponseEntity.ok(accountService.getUser(userUUID));
    }

    // Any logged-in user can see another user's name (and nothing else)
    @GetMapping("/names/{uuid}")
    public ResponseEntity<String> getName(@RequestHeader("Authorization") String jwt, @PathVariable String uuid) throws NoSuchEntityException, InvalidJwtException {
        verifyIdentity(jwt);
        return ResponseEntity.ok(accountService.getUser(uuid).getName());
    }

    // Fetch specific profile
    @GetMapping("/profiles/{uuid}")
    public ResponseEntity<Profile> getProfile(@RequestHeader("Authorization") String jwt) throws NoSuchEntityException, InvalidJwtException {
        String userUUID = verifyIdentity(jwt);
        return ResponseEntity.ok(accountService.getProfile(userUUID));
    }

    // Edit profile endpoint
    @PutMapping("/profiles")
    public ResponseEntity<String> editProfile(@RequestHeader("Authorization") String jwt, RequestEntity<Profile> req) throws NoSuchEntityException, InvalidJwtException {
        String userUUID = verifyIdentity(jwt);
        Profile profile = req.getBody();
        profile.setUuid(userUUID);
        accountService.editProfile(profile);
        return ResponseEntity.ok("Success\n");
    }

}
