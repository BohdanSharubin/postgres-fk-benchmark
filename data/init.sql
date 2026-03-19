
-- 1000k користувачів
INSERT INTO users (username, email)
SELECT 'user_' || i, 'user_' || i || '@example.com'
FROM generate_series(1,1000000) AS s(i);

-- 1000k лайків
INSERT INTO likes (text)
SELECT 'like_' || i
FROM generate_series(1,1000000) AS s(i);