package io.github.vtinder.api.security;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingRequestHeaderException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static io.github.vtinder.api.security.JwtAuthConfiguration.InvalidJwtException;

@RestControllerAdvice
public class JwtExceptionHandler {

    @ExceptionHandler(InvalidJwtException.class)
    public ResponseEntity<String> handleInvalidJwt(InvalidJwtException e) {
        return unauthorized();
    }

    @ExceptionHandler(MissingRequestHeaderException.class)
    public ResponseEntity<String> handleMissingHeader(MissingRequestHeaderException e) {
        if (HttpHeaders.AUTHORIZATION.equalsIgnoreCase(e.getHeaderName())) return unauthorized();
        return ResponseEntity.badRequest().body("Missing header " + e.getHeaderName() + "\n");
    }

    private ResponseEntity<String> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .header(HttpHeaders.WWW_AUTHENTICATE, "Bearer")
            .body("Unauthorized\n");
    }

}
