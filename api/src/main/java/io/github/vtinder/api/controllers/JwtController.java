package io.github.vtinder.api.controllers;

import io.github.vtinder.api.repositories.VTinderRepository;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.time.Duration;
import java.time.Instant;
import java.util.Date;

@RestController
public class AuthController {

    private final VTinderRepository repository;
    private final Duration jwtLife = Duration.ofSeconds(3600); // Tokens expire after an hour
    private final String jwtSecret = "super-secure-server-secret";

    @Autowired
    public AuthController(VTinderRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/auth/{userUUID}/{password}")
    public ResponseEntity<Void> issueJwt(@PathVariable String userUUID, @PathVariable String password) {
        String hashedPassword = repository.getHashedPassword(userUUID, password);
        boolean authenticated = BCrypt.checkpw(password, hashedPassword);

        if (!authenticated) return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        Instant now = Instant.now();

        String jwt = Jwts.builder()
            .issuer("VTinderAPI")
            .subject(userUUID)
            .issuedAt(Date.from(now))
            .expiration(Date.from(now.plus(jwtLife)))
            .signWith(Keys.hmacShaKeyFor(jwtSecret.getBytes()))
            .compact();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + jwt);

        return ResponseEntity.ok().headers(headers).build();
    }

}
