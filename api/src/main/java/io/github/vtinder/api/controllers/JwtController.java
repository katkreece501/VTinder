package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.User;
import io.github.vtinder.api.repositories.VTinderRepository;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

import static io.github.vtinder.api.security.JwtAuthConfiguration.issueJwt;

@RestController
public class JwtController {

    private final VTinderRepository repository;

    @Autowired
    public JwtController(VTinderRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/auth/{email}/{password}")
    public ResponseEntity<String> issueJwtForUser(@PathVariable String email, @PathVariable String password) {
        Optional<User> user = repository.findUserByEmail(email);
        // Unknown users get the same 401 as a wrong password
        boolean authenticated = user
                .flatMap(u -> repository.getHashedPassword(u.getUuid(), password))
                .map(hashedPassword -> BCrypt.checkpw(password, hashedPassword))
                .orElse(false);

        if (!authenticated) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        String userUUID = user.get().getUuid();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + issueJwt(userUUID));

        // The app needs the uuid to know who just logged in
        return ResponseEntity.ok().headers(headers).body(userUUID);
    }

}
