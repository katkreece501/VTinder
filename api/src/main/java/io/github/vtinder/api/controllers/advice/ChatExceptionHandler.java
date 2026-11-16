package io.github.vtinder.api.controllers.advice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static io.github.vtinder.api.repositories.VTinderRepository.NotMatchedException;
import static io.github.vtinder.api.services.ChatService.InvalidMessageException;
import static io.github.vtinder.api.services.ChatService.InvalidReportException;

@RestControllerAdvice
public class ChatExceptionHandler {

    @ExceptionHandler(NotMatchedException.class)
    public ResponseEntity<String> handleNotMatched(NotMatchedException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Not allowed to chat with this user\n");
    }

    @ExceptionHandler(InvalidMessageException.class)
    public ResponseEntity<String> handleInvalidMessage(InvalidMessageException e) {
        return ResponseEntity.badRequest().body(e.getMessage() + "\n");
    }

    @ExceptionHandler(InvalidReportException.class)
    public ResponseEntity<String> handleInvalidReport(InvalidReportException e) {
        return ResponseEntity.badRequest().body(e.getMessage() + "\n");
    }

}
