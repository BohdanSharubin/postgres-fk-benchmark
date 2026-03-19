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
    userId INT NOT NULL REFERENCES users(id),
    like_id INT NOT NULL REFERENCES likes(id),
    PRIMARY KEY(userId, like_id)
);
