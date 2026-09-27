CREATE TABLE IF NOT EXISTS users (
    uuid TEXT NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    is_moderator INTEGER NOT NULL CHECK (is_moderator IN (0, 1)) -- sqlite boolean
);

CREATE TABLE IF NOT EXISTS profiles (
    user_uuid INTEGER NOT NULL UNIQUE,
    school_year TEXT NOT NULL,
    bio TEXT NOT NULL,
    major TEXT NOT NULL,
    interests TEXT NOT NULL,
    grad_date TEXT NOT NULL,
    next_steps TEXT NOT NULL,
    age INTEGER NOT NULL,
    height_inches INTEGER NOT NULL,
    gender TEXT NOT NULL,
    image BLOB NOT NULL,

    FOREIGN KEY (user_uuid) REFERENCES users (uuid)
);

CREATE TABLE IF NOT EXISTS likes (
    liker_uuid TEXT NOT NULL,
    liked_uuid TEXT NOT NULL,

    FOREIGN KEY (liker_uuid) REFERENCES users (uuid),
    FOREIGN KEY (liked_uuid) REFERENCES users (uuid)
);

CREATE TABLE IF NOT EXISTS messages (
    sender_uuid TEXT NOT NULL,
    receiver_uuid TEXT NOT NULL,
    timestamp INTEGER NOT NULL, -- store in unix epoch format
    message TEXT NOT NULL,

    FOREIGN KEY (sender_uuid) REFERENCES users (uuid),
    FOREIGN KEY (receiver_uuid) REFERENCES users (uuid)
);