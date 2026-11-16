package io.github.vtinder.api.controllers.advice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static io.github.vtinder.api.security.JwtAuthConfiguration.BannedUserException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.NotModeratorException;

@RestControllerAdvice
public class AuthExceptionHandler {

    // Takes precedence over JwtExceptionHandler's 401 because it's the more specific type
    @ExceptionHandler(BannedUserException.class)
    public ResponseEntity<String> handleBanned(BannedUserException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("This account has been banned\n");
    }

    @ExceptionHandler(NotModeratorException.class)
    public ResponseEntity<String> handleNotModerator(NotModeratorException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Moderator privileges required\n");
    }

}
