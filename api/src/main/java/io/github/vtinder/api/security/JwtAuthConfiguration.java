package io.github.vtinder.api.security;

import io.github.vtinder.api.repositories.VTinderRepository;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;

import javax.crypto.SecretKey;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;

@Configuration
public class JwtAuthConfiguration {

    public static final Duration JWT_LIFE = Duration.ofSeconds(3600); // Tokens expire after an hour
    // HMAC keys must be at least 256 bits
    public static final SecretKey JWT_SECRET = Keys.hmacShaKeyFor("super-secure-server-secret-padded-to-32+bytes-so-that-it-works".getBytes());

    // Static so verifyIdentity can stay static; Spring sets it when it builds this bean at startup
    private static VTinderRepository repository;

    @Autowired
    public JwtAuthConfiguration(VTinderRepository repository) {
        JwtAuthConfiguration.repository = repository;
    }

    public static String issueJwt(String userUUID) {
        Instant now = Instant.now();
        return Jwts.builder()
            .issuer("VTinderAPI")
            .subject(userUUID)
            .issuedAt(Date.from(now))
            .expiration(Date.from(now.plus(JWT_LIFE)))
            .signWith(JWT_SECRET)
            .compact();
    }

    public static String verifyIdentity(String jwt) throws InvalidJwtException {
//        System.out.println("Token: " + jwt);
//        if (jwt.equals("Bearer mastertoken9000")) return "11111111-1111-4111-8111-111111111111";
        if (jwt.startsWith("Bearer ")) jwt = jwt.substring("Bearer ".length());
        String userUUID;
        try {
            userUUID = Jwts.parser().verifyWith(JWT_SECRET).build()
                    .parseSignedClaims(jwt).getPayload().getSubject();
        } catch (JwtException | IllegalArgumentException e) {
            throw new InvalidJwtException(e.getMessage());
        }
        // Checked on every request so a ban takes effect before the user's token expires
        requireNotBanned(userUUID);
        return userUUID;
    }

    // Like verifyIdentity, but also requires the caller to be a moderator
    public static String verifyModerator(String jwt) throws InvalidJwtException, NotModeratorException {
        String userUUID = verifyIdentity(jwt);
        if (!repository.isModerator(userUUID)) {
            throw new NotModeratorException(userUUID + " is not a moderator");
        }
        return userUUID;
    }

    public static void requireNotBanned(String userUUID) throws BannedUserException {
        if (repository.isBanned(userUUID)) {
            throw new BannedUserException(userUUID + " is banned");
        }
    }

    public static class InvalidJwtException extends Exception {
        public InvalidJwtException(String msg) {super(msg);}
    }

    public static class BannedUserException extends InvalidJwtException {
        public BannedUserException(String msg) {super(msg);}
    }

    public static class NotModeratorException extends Exception {
        public NotModeratorException(String msg) {super(msg);}
    }

}
