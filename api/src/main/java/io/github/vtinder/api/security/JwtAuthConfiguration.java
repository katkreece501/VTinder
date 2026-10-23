package io.github.vtinder.api.security;

import io.github.vtinder.api.repositories.VTinderRepository;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

@Configuration
public class JwtAuthConfig {

    private final VTinderRepository repository;

    @Autowired
    public JwtAuthAspect(VTinderRepository repository) {
        this.repository = repository;
    }


}
