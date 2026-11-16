CREATE TABLE IF NOT EXISTS users (
    uuid TEXT NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    is_moderator INTEGER NOT NULL CHECK (is_moderator IN (0, 1)), -- sqlite boolean
    banned INTEGER NOT NULL CHECK (banned IN (0, 1)), -- sqlite boolean

    CHECK (NOT (banned = 1 AND is_moderator = 1)) -- moderators cannot be banned
);

CREATE TABLE IF NOT EXISTS profiles (
    user_uuid INTEGER NOT NULL UNIQUE,
    school_year TEXT NOT NULL,
    bio TEXT NOT NULL,
    major TEXT NOT NULL,
    interests TEXT NOT NULL,
    grad_date TEXT NOT NULL,
    next_steps TEXT NOT NULL,
    age INTEGER,
    height_inches INTEGER,
    gender TEXT NOT NULL,
    image BLOB,

    FOREIGN KEY (user_uuid) REFERENCES users (uuid)
);

CREATE TABLE IF NOT EXISTS likes (
    liker_uuid TEXT NOT NULL,
    liked_uuid TEXT NOT NULL,

    FOREIGN KEY (liker_uuid) REFERENCES users (uuid),
    FOREIGN KEY (liked_uuid) REFERENCES users (uuid)
);

CREATE TABLE IF NOT EXISTS dislikes (
    disliker_uuid TEXT NOT NULL,
    disliked_uuid TEXT NOT NULL,

    FOREIGN KEY (disliker_uuid) REFERENCES users (uuid),
    FOREIGN KEY (disliked_uuid) REFERENCES users (uuid)
);

CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sender_uuid TEXT NOT NULL,
    receiver_uuid TEXT NOT NULL,
    timestamp INTEGER NOT NULL, -- store in unix epoch format
    message TEXT NOT NULL,

    FOREIGN KEY (sender_uuid) REFERENCES users (uuid),
    FOREIGN KEY (receiver_uuid) REFERENCES users (uuid)
);

CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages (sender_uuid, receiver_uuid, id);

CREATE TABLE IF NOT EXISTS reports (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    reporter_uuid TEXT NOT NULL,
    reported_uuid TEXT NOT NULL,
    timestamp INTEGER NOT NULL, -- store in unix epoch format
    reason TEXT NOT NULL,

    FOREIGN KEY (reporter_uuid) REFERENCES users (uuid),
    FOREIGN KEY (reported_uuid) REFERENCES users (uuid)
);
