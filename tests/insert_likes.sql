\set user_id random(1,100000)
\set post_id random(1,1000000)

BEGIN;

INSERT INTO likes(user_id, post_id)
VALUES (:user_id, :post_id)
ON CONFLICT DO NOTHING;

END;