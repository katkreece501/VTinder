package io.github.vtinder.api.controllers.advice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static io.github.vtinder.api.repositories.VTinderRepository.CannotBanModeratorException;
import static io.github.vtinder.api.services.AccountService.NoSuchEntityException;

@RestControllerAdvice
public class ModeratorExceptionHandler {

    @ExceptionHandler(CannotBanModeratorException.class)
    public ResponseEntity<String> handleCannotBanModerator(CannotBanModeratorException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Moderators cannot be banned\n");
    }

    // Advice is global, so this also covers AccountController and ChatController lookups
    @ExceptionHandler(NoSuchEntityException.class)
    public ResponseEntity<String> handleNoSuchEntity(NoSuchEntityException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage() + "\n");
    }

}
