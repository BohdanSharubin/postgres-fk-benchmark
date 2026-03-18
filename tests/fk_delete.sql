\set userId random(1,1000000)

BEGIN;

DELETE FROM users_likes
WHERE userId = :userId;

DELETE FROM likes
WHERE id IN (
    SELECT like_id FROM users_likes WHERE userId = :userId
);

DELETE FROM users
WHERE id = :userId;

COMMIT;

--BEGIN;

--SELECT id
--FROM users
--ORDER BY random()
--LIMIT 1
--FOR UPDATE
--\gset

--DELETE FROM users_likes
--WHERE userId = :id;

--DELETE FROM users
--WHERE id = :id;

--COMMIT;