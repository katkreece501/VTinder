package io.github.vtinder.api.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AccountController {

    // Login endpoints
    @GetMapping("/name")
    public String getName() {
        return "";
    }

    // Receive image via a Swift "Data" type


}
