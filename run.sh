#!/bin/bash
set -e

RESULT_DIR=/benchmark/results
mkdir -p $RESULT_DIR

echo "Starting postgres..."

docker-entrypoint.sh postgres &

until pg_isready
do
  sleep 2
done

echo "Postgres ready"

echo "===== FK TEST ====="

psql -U postgres -f schema/schema_fk.sql
psql -U postgres -f data/init.sql

echo "Running INSERT benchmark (FK)"

pgbench -U postgres -c 20 -j 4 -T 60 \
-f tests/insert_likes.sql postgres \
> $RESULT_DIR/fk_insert.txt 2>&1

echo "Running DELETE benchmark (FK)"

pgbench -U postgres -c 20 -j 4 -T 60 \
-f tests/delete_posts.sql postgres \
> $RESULT_DIR/fk_delete.txt 2>&1


echo "Cleaning database"

psql -U postgres -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"


echo "===== SCHEMA WITHOUT FK TEST ====="

psql -U postgres -f schema/schema_no_fk.sql
psql -U postgres -f data/seed.sql

echo "Running INSERT benchmark (NO FK)"

pgbench -U postgres -c 20 -j 4 -T 60 \
-f tests/insert_likes.sql postgres \
> $RESULT_DIR/no_fk_insert.txt 2>&1

echo "Running DELETE benchmark (NO FK)"

pgbench -U postgres -c 20 -j 4 -T 60 \
-f tests/delete_posts.sql postgres \
> $RESULT_DIR/no_fk_delete.txt 2>&1


echo "Benchmark finished"