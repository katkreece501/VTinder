package io.github.vtinder.api.repositories;

import io.github.vtinder.api.models.Dislike;
import io.github.vtinder.api.models.Like;
import io.github.vtinder.api.models.Message;
import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.models.User;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;
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

    public Optional<User> findUserByEmail(String email) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
                "SELECT * FROM users WHERE email = ?")
                .bind(0, email).mapTo(User.class).findOne();
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

    public int like(Like like) {
        return jdbi.withHandle(handle -> {
            return handle.createUpdate(
                "INSERT INTO likes (liker_uuid, liked_uuid) VALUES (:liker, :liked)"
            ).bindBean(like).execute();
        });
    }

    public int dislike(Dislike dislike) {
        return jdbi.withHandle(handle -> {
            return handle.createUpdate(
                "INSERT INTO dislikes (disliker_uuid, disliked_uuid) VALUES (:disliker, :disliked)"
            ).bindBean(dislike).execute();
        });
    }

    public List<Profile> getFeed(String uuid) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
                "SELECT * FROM profiles p RIGHT JOIN users u ON u.uuid = p.user_uuid WHERE "
                +   "user_uuid NOT IN (SELECT liked_uuid FROM likes WHERE liker_uuid = :uuid) "
                +   "AND user_uuid NOT IN (SELECT disliked_uuid FROM dislikes WHERE disliker_uuid = :uuid) "
                +   "AND NOT p.user_uuid = :uuid"
            ).bind("uuid", uuid).mapTo(Profile.class).list();
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

    public Optional<String> getHashedPassword(String userUUID, String hashPwd) {
        return jdbi.withHandle(handle -> {
           return handle.createQuery("SELECT password FROM users WHERE uuid = ?")
               .bind(0, userUUID).mapTo(String.class).findOne();
        });
    }

    public List<Profile> getMatches(String userUUID) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
                "SELECT p.*, u.name FROM profiles p RIGHT JOIN users u ON u.uuid = p.user_uuid "
                +   "WHERE user_uuid IN (SELECT liked_uuid FROM likes WHERE liker_uuid = :uuid) "
                +   "AND user_uuid IN (SELECT liker_uuid FROM likes WHERE liked_uuid = :uuid)")
                   .bind("uuid", userUUID).mapTo(Profile.class).list();
        });
    }

    private static final int MESSAGE_PAGE_SIZE = 20;

    public List<Message> getMessages(String userUUID, String otherUUID, Long beforeId, Long afterId)
            throws NotMatchedException {
        String conversation =
                "SELECT *, sender_uuid = :uuid AS from_me FROM messages "
            +   "WHERE ((sender_uuid = :uuid AND receiver_uuid = :other) "
            +   "OR (sender_uuid = :other AND receiver_uuid = :uuid))";
        String sql;
        if (afterId != null) {
            sql = conversation + " AND id > :afterId ORDER BY id";
        } else {
            String before = beforeId != null ? " AND id < :beforeId" : "";
            sql = "SELECT * FROM (" + conversation + before + " ORDER BY id DESC LIMIT :limit) ORDER BY id";
        }
        return jdbi.withHandle(handle -> {
            requireMatch(handle, userUUID, otherUUID);
            // Jdbi rejects bindings the SQL doesn't use, so only bind what this shape needs
            Query query = handle.createQuery(sql).bind("uuid", userUUID).bind("other", otherUUID);
            if (afterId != null) {
                query.bind("afterId", afterId);
            } else {
                query.bind("limit", MESSAGE_PAGE_SIZE);
                if (beforeId != null) query.bind("beforeId", beforeId);
            }
            return query.mapTo(Message.class).list();
        });
    }

    public int sendMessage(Message message) throws NotMatchedException {
        return jdbi.inTransaction(handle -> {
            requireMatch(handle, message.getSenderUUID(), message.getReceiverUUID());
            return handle.createUpdate(
                "INSERT INTO messages (sender_uuid, receiver_uuid, timestamp, message) "
                +   "VALUES (:senderUUID, :receiverUUID, :timestamp, :message)")
                    .bind("senderUUID", message.getSenderUUID())
                    .bind("receiverUUID", message.getReceiverUUID())
                    .bind("timestamp", message.getTimestamp().getEpochSecond())
                    .bind("message", message.getMessage()).execute();
        });
    }

    // Throws unless both users have liked each other
    static void requireMatch(Handle handle, String userUUID, String otherUUID) throws NotMatchedException {
        boolean matched = handle.createQuery(
            "SELECT EXISTS (SELECT 1 FROM likes WHERE liker_uuid = :uuid AND liked_uuid = :other) "
            +   "AND EXISTS (SELECT 1 FROM likes WHERE liker_uuid = :other AND liked_uuid = :uuid)")
                .bind("uuid", userUUID).bind("other", otherUUID).mapTo(Boolean.class).one();
        if (!matched) {
            throw new NotMatchedException(userUUID + " and " + otherUUID + " are not matched");
        }
    }

    public static class NotMatchedException extends Exception {
        public NotMatchedException(String msg) {super(msg);}
    }

}
