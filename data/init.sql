
-- 1000k користувачів
INSERT INTO users (username, email)
SELECT 'user_' || i, 'user_' || i || '@example.com'
FROM generate_series(1,1000000) AS s(i);

-- 1000k лайків
INSERT INTO likes (text)
SELECT 'like_' || i
FROM generate_series(1,1000000) AS s(i);

-- користувачі лайкають випадково 1–5 лайків
--INSERT INTO users_likes (userId, like_id)
--SELECT u.id, l.id
--FROM users u
--JOIN likes l ON l.id = (1 + random() * 1000000)::int
--WHERE (random() < 0.05);  -- приблизно 5% лайків на користувача