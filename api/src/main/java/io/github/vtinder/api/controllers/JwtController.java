package io.github.vtinder.api.controllers;

import io.github.vtinder.api.repositories.VTinderRepository;
import io.jsonwebtoken.Jwts;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.Date;

import static io.github.vtinder.api.security.JwtAuthConfiguration.JWT_LIFE;
import static io.github.vtinder.api.security.JwtAuthConfiguration.JWT_SECRET;

@RestController
public class JwtController {

    private final VTinderRepository repository;

    @Autowired
    public JwtController(VTinderRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/auth/{userUUID}/{password}")
    public ResponseEntity<Void> issueJwt(@PathVariable String userUUID, @PathVariable String password) {
        // Unknown users get the same 401 as a wrong password
        boolean authenticated = repository.getHashedPassword(userUUID, password)
                .map(hashedPassword -> BCrypt.checkpw(password, hashedPassword))
                .orElse(false);

        if (!authenticated) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        Instant now = Instant.now();

        String jwt = Jwts.builder()
            .issuer("VTinderAPI")
            .subject(userUUID)
            .issuedAt(Date.from(now))
            .expiration(Date.from(now.plus(JWT_LIFE)))
            .signWith(JWT_SECRET)
            .compact();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + jwt);

        return ResponseEntity.ok().headers(headers).build();
    }

}
