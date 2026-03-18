\set userId random(1,1000000)
\set like_id random(1,1000000)

BEGIN;

INSERT INTO users_likes (userId, like_id)
VALUES (:userId, :like_id);
---ON CONFLICT DO NOTHING;

COMMIT;