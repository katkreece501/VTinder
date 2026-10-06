package io.github.vtinder.api.repositories;

import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.models.User;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Batch;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
public class VTinderRepository {

    private final Jdbi jdbi;

    @Autowired
    public VTinderRepository(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    public int registerUser(User user, String password) {
        return jdbi.inTransaction(handle -> {
            int rowsEdited = 0;
            rowsEdited += handle.createUpdate(
                "INSERT INTO users (uuid, name, email, password, is_moderator) "
                +   "VALUES (:u.uuid, :u.name, :u.email, :password, :u.isModerator)")
                    .bindBean("u", user)
                    .bind("password", password).execute();
            rowsEdited += handle.createUpdate(
                "INSERT INTO profiles "
                +   "(user_uuid, school_year, bio, major, interests, grad_date, next_steps, age, "
                +   "height_inches, gender, image) VALUES (?, \"\", \"\", \"\", \"\", \"\", \"\", "
                +   "NULL, NULL, \"\", NULL)").bind(0, user.getUuid()).execute();
            return rowsEdited;
        });
    }

    public Optional<User> findUserByUuid(String uuid) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
                "SELECT * FROM users WHERE uuid = ?")
                .bind(0, uuid).mapTo(User.class).findOne();
        });
    }

    public Optional<Profile> findProfileByUuid(String uuid) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
            "SELECT p.*, u.name FROM profiles p RIGHT JOIN users u"
                +   " ON p.user_uuid = u.uuid WHERE u.uuid = ?")
                .bind(0, uuid).mapTo(Profile.class).findOne();
        });
    }

    public int editProfile(Profile profile) {
        return jdbi.withHandle(handle -> {
            return handle.createUpdate(
                "UPDATE profiles SET school_year = :year, bio = :bio, major = :major, interests = :interests, "
                +   "grad_date = :gradDate, next_steps = :nextSteps, age = :age, height_inches = :heightInches, "
                +   "gender = :gender, image = :image WHERE user_uuid = :uuid").bindBean(profile).execute();
        });
    }

    public List<Profile> getAllProfiles() {
        return jdbi.withHandle(handle ->
            handle.createQuery(
                "SELECT p.*, u.name FROM profiles p RIGHT JOIN users u"
                +   " ON p.user_uuid = u.uuid")
                .mapTo(Profile.class).list()
        );
    }

}
