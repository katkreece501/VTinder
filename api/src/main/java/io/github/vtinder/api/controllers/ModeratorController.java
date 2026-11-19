package io.github.vtinder.api.controllers;

import io.github.vtinder.api.models.Report;
import io.github.vtinder.api.services.ModeratorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static io.github.vtinder.api.repositories.VTinderRepository.CannotBanModeratorException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.InvalidJwtException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.NotModeratorException;
import static io.github.vtinder.api.security.JwtAuthConfiguration.verifyModerator;
import static io.github.vtinder.api.services.AccountService.NoSuchEntityException;

@RestController
public class ModeratorController {

    private final ModeratorService moderatorService;

    @Autowired
    public ModeratorController(ModeratorService moderatorService) {
        this.moderatorService = moderatorService;
    }

    @GetMapping("/reports")
    public ResponseEntity<List<Report>> getReports(@RequestHeader("Authorization") String jwt)
            throws InvalidJwtException, NotModeratorException {
        verifyModerator(jwt);
        return ResponseEntity.ok(moderatorService.getReports());
    }

    @DeleteMapping("/reports/{id}")
    public ResponseEntity<String> deleteReport(@RequestHeader("Authorization") String jwt, @PathVariable("id") long id)
            throws InvalidJwtException, NotModeratorException, NoSuchEntityException {
        verifyModerator(jwt);
        moderatorService.deleteReport(id);
        return ResponseEntity.ok("Success\n");
    }

    @PostMapping("/ban/{uuid}")
    public ResponseEntity<String> banUser(@RequestHeader("Authorization") String jwt, @PathVariable("uuid") String bannedUUID)
            throws InvalidJwtException, NotModeratorException, NoSuchEntityException, CannotBanModeratorException {
        verifyModerator(jwt);
        moderatorService.banUser(bannedUUID);
        return ResponseEntity.ok("Success\n");
    }

}
