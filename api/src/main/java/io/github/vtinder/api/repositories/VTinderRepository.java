package io.github.vtinder.api.repositories;

import io.github.vtinder.api.models.Dislike;
import io.github.vtinder.api.models.Like;
import io.github.vtinder.api.models.Message;
import io.github.vtinder.api.models.Profile;
import io.github.vtinder.api.models.Report;
import io.github.vtinder.api.models.User;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;
import org.jdbi.v3.core.statement.UnableToExecuteStatementException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.sqlite.SQLiteErrorCode;
import org.sqlite.SQLiteException;

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
                "INSERT INTO users (uuid, name, email, password, is_moderator, banned) "
                +   "VALUES (:u.uuid, :u.name, :u.email, :password, :u.isModerator, :u.banned)")
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
                "SELECT * FROM users WHERE uuid = ? AND banned = 0")
                .bind(0, uuid).mapTo(User.class).findOne();
        });
    }

    // Deliberately includes banned users so login can tell them they're banned
    public Optional<User> findUserByEmail(String email) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
                "SELECT * FROM users WHERE email = ?")
                .bind(0, email).mapTo(User.class).findOne();
        });
    }

    // Moderators pass includeBanned so they can still look at banned users
    public Optional<Profile> findProfileByUuid(String uuid, boolean includeBanned) {
        String banned = includeBanned ? "" : " AND u.banned = 0";
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
            "SELECT p.*, u.name FROM profiles p RIGHT JOIN users u"
                +   " ON p.user_uuid = u.uuid WHERE u.uuid = ?" + banned)
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
                +   "AND NOT p.user_uuid = :uuid AND u.banned = 0 AND u.is_moderator = 0"
            ).bind("uuid", uuid).mapTo(Profile.class).list();
        });
    }

    // Moderator view, so banned users and moderators are included
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
                +   "WHERE u.banned = 0 AND ((u.is_moderator = 0 "
                +   "AND user_uuid IN (SELECT liked_uuid FROM likes WHERE liker_uuid = :uuid) "
                +   "AND user_uuid IN (SELECT liker_uuid FROM likes WHERE liked_uuid = :uuid)) "
                // Moderators aren't matches, but daters need to see moderators who reached out
                +   "OR (u.is_moderator = 1 AND u.uuid IN "
                +   "(SELECT sender_uuid FROM messages WHERE receiver_uuid = :uuid)))")
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
            chatAllowed(handle, userUUID, otherUUID);
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
            chatAllowed(handle, message.getSenderUUID(), message.getReceiverUUID());
            return handle.createUpdate(
                "INSERT INTO messages (sender_uuid, receiver_uuid, timestamp, message) "
                +   "VALUES (:senderUUID, :receiverUUID, :timestamp, :message)")
                    .bind("senderUUID", message.getSenderUUID())
                    .bind("receiverUUID", message.getReceiverUUID())
                    .bind("timestamp", message.getTimestamp().getEpochSecond())
                    .bind("message", message.getMessage()).execute();
        });
    }

    // Throws unless both users exist and aren't banned, and either one is a moderator or they've liked each other
    static void chatAllowed(Handle handle, String userUUID, String otherUUID) throws NotMatchedException {
        boolean allowed = handle.createQuery(
            "SELECT (SELECT COUNT(*) FROM users WHERE uuid IN (:uuid, :other) AND banned = 0) = 2 "
            +   "AND (EXISTS (SELECT 1 FROM users WHERE uuid IN (:uuid, :other) AND is_moderator = 1) "
            +   "OR (EXISTS (SELECT 1 FROM likes WHERE liker_uuid = :uuid AND liked_uuid = :other) "
            +   "AND EXISTS (SELECT 1 FROM likes WHERE liker_uuid = :other AND liked_uuid = :uuid)))")
                .bind("uuid", userUUID).bind("other", otherUUID).mapTo(Boolean.class).one();
        if (!allowed) {
            throw new NotMatchedException(userUUID + " is not allowed to chat with " + otherUUID);
        }
    }

    // Auth checks see banned users, so these deliberately skip the banned filter
    public boolean isBanned(String uuid) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery("SELECT banned FROM users WHERE uuid = ?")
                .bind(0, uuid).mapTo(Boolean.class).findOne().orElse(false);
        });
    }

    public boolean isModerator(String uuid) {
        return jdbi.withHandle(handle -> {
            return handle.createQuery("SELECT is_moderator FROM users WHERE uuid = ?")
                .bind(0, uuid).mapTo(Boolean.class).findOne().orElse(false);
        });
    }

    public int banUser(String uuid) throws CannotBanModeratorException {
        return jdbi.withHandle(handle -> {
            try {
                return handle.createUpdate("UPDATE users SET banned = 1 WHERE uuid = ?")
                    .bind(0, uuid).execute();
            } catch (UnableToExecuteStatementException e) {
                // The users table CHECK constraint is what stops moderators from being banned
                if (e.getCause() instanceof SQLiteException sqlite
                        && sqlite.getResultCode() == SQLiteErrorCode.SQLITE_CONSTRAINT_CHECK) {
                    throw new CannotBanModeratorException(uuid + " is a moderator");
                }
                throw e;
            }
        });
    }

    public int addReport(Report report) {
        return jdbi.withHandle(handle -> {
            return handle.createUpdate(
                "INSERT INTO reports (reporter_uuid, reported_uuid, timestamp, reason) "
                +   "VALUES (:reporter, :reported, :timestamp, :reason)")
                    .bind("reporter", report.getReporter())
                    .bind("reported", report.getReported())
                    .bind("timestamp", report.getTimestamp().getEpochSecond())
                    .bind("reason", report.getReason()).execute();
        });
    }

    // Moderator view, so reports involving banned users are included
    public List<Report> getReports() {
        return jdbi.withHandle(handle -> {
            return handle.createQuery(
                "SELECT r.*, a.name AS reporter_name, b.name AS reported_name FROM reports r "
                +   "JOIN users a ON a.uuid = r.reporter_uuid "
                +   "JOIN users b ON b.uuid = r.reported_uuid "
                +   "ORDER BY r.timestamp DESC, r.id DESC")
                .mapTo(Report.class).list();
        });
    }

    public int deleteReport(long id) {
        return jdbi.withHandle(handle -> {
            return handle.createUpdate("DELETE FROM reports WHERE id = ?")
                .bind(0, id).execute();
        });
    }

    public static class NotMatchedException extends Exception {
        public NotMatchedException(String msg) {super(msg);}
    }

    public static class CannotBanModeratorException extends Exception {
        public CannotBanModeratorException(String msg) {super(msg);}
    }

}
