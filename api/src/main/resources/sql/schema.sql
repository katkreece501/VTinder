CREATE TABLE IF NOT EXISTS profiles (
    id INTEGER NOT NULL,
    name TEXT NOT NULL,
    year TEXT NOT NULL,
    bio TEXT NOT NULL,
    major TEXT NOT NULL,
    interests TEXT NOT NULL,
    gradDate TEXT NOT NULL,
    nextSteps TEXT NOT NULL,
    age INTEGER NOT NULL,
    heightInches INTEGER NOT NULL,
    gender TEXT NOT NULL,
    image BLOB NOT NULL
)