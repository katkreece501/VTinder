package io.github.vtinder.api.services;

import io.github.vtinder.api.models.Dislike;
import io.github.vtinder.api.models.Like;
import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.repositories.VTinderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class FeedService {

    private VTinderRepository repository;

    @Autowired
    public FeedService(VTinderRepository repository) {
        this.repository = repository;
    }

    public void like(Like like) throws FeedActionUnsuccessfulException {
        if (repository.like(like) == 0) {
            throw new FeedActionUnsuccessfulException("Like unsuccessful");
        }
    }

    public void dislike(Dislike dislike) throws FeedActionUnsuccessfulException {
        if (repository.dislike(dislike) == 0) {
            throw new FeedActionUnsuccessfulException("Dislike unsuccessful");
        }
    }

    public List<Profile> getFeed(String uuid) {
        return repository.getFeed(uuid);
    }

    public static class FeedActionUnsuccessfulException extends Exception {
        public FeedActionUnsuccessfulException(String msg) {super(msg);}
    }
}
