package io.github.vtinder.api.services;

import io.github.vtinder.api.repositories.VTinderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FeedService {

    private VTinderRepository repository;

    @Autowired
    public FeedService(VTinderRepository repository) {
        this.repository = repository;
    }



}
