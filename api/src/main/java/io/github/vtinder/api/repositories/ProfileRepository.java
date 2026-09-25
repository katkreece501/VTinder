package io.github.vtinder.api.repositories;

import io.github.vtinder.api.models.Profile;
import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class ProfileRepository {

    private Jdbi jdbi;

    @Autowired
    public ProfileRepository(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    public Profile getProfile(Integer id) {
        return null;
    }

    public List<Profile> getAllProfiles() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM profiles")
                        .mapTo(Profile.class).list()
        );
    }

}
