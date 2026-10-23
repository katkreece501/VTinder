package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Registration;
import io.github.vtinder.api.services.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import static io.github.vtinder.api.security.JwtAuthConfiguration.issueJwt;
import static io.github.vtinder.api.services.AccountService.RegistrationFailedException;

@RestController
public class RegistrationController {

    private final AccountService accountService;

    @Autowired
    public RegistrationController(AccountService accountService) {
        this.accountService = accountService;
    }

    // Create account user; new users are logged in right away
    @PostMapping("/accounts")
    public ResponseEntity<String> registerUser(RequestEntity<Registration> req) throws RegistrationFailedException {
        Registration registration = req.getBody();
        accountService.registerUser(registration);

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + issueJwt(registration.getUuid()));

        return ResponseEntity.ok().headers(headers).body("Success\n");
    }

}
