CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT NOT NULL
);

CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    text TEXT
);

CREATE TABLE users_likes (
    userId INT NOT NULL,
    like_id INT NOT NULL,
    PRIMARY KEY(userId, like_id)
);
create INdex on users_likes (like_id)
