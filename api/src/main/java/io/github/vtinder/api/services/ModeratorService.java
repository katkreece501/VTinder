package io.github.vtinder.api.services;

import io.github.vtinder.api.models.Report;
import io.github.vtinder.api.repositories.VTinderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

import static io.github.vtinder.api.repositories.VTinderRepository.CannotBanModeratorException;
import static io.github.vtinder.api.services.AccountService.NoSuchEntityException;

@Component
public class ModeratorService {

    private final VTinderRepository repository;

    @Autowired
    public ModeratorService(VTinderRepository repository) {
        this.repository = repository;
    }

    public List<Report> getReports() {
        return repository.getReports();
    }

    public void deleteReport(long id) throws NoSuchEntityException {
        if (repository.deleteReport(id) == 0) {
            throw new NoSuchEntityException("No report with id " + id);
        }
    }

    public void banUser(String uuid) throws NoSuchEntityException, CannotBanModeratorException {
        if (repository.banUser(uuid) == 0) {
            throw new NoSuchEntityException("No user with uuid " + uuid);
        }
    }

}
