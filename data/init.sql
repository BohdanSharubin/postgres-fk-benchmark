INSERT INTO users(username, email)
SELECT
    'user_' || g,
    'user_' || g || '@example.com'
FROM generate_series(1,100000) g;

INSERT INTO posts(author_id, text)
SELECT
    (random()*99999)::int + 1,
    'post text'
FROM generate_series(1,1000000);