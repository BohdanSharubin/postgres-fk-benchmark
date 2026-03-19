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

echo "Initializing pgbench..."

echo "===== FK TEST ====="

psql -U postgres -f schema/schema_fk.sql
psql -U postgres -f data/init.sql

echo "Analyzing..."
psql -U postgres -c "ANALYZE;"

echo "Running INSERT benchmark (FK)"

pgbench -U postgres -c 20 -j 4 -T 180  \
-f tests/insert_likes.sql postgres \
> $RESULT_DIR/fk_insert.txt 2>&1

echo "Analyzing..."
psql -U postgres -c "ANALYZE;"

echo "Running DELETE benchmark (FK)"

pgbench -U postgres -c 1 -j 1 -T 180  \
-f tests/fk_delete.sql postgres \
> $RESULT_DIR/fk_delete.txt 2>&1

echo "Cleaning database"

psql -U postgres -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

echo "===== FK WITHOUT INDEXES TEST ====="

psql -U postgres -f schema/schema_fk_without_indexes.sql
psql -U postgres -f data/init.sql

echo "Analyzing..."
psql -U postgres -c "ANALYZE;"

echo "Running INSERT benchmark (FK WITHOUT INDEXES)"

pgbench -U postgres -c 20 -j 4 -T 180  \
-f tests/insert_likes.sql postgres \
> $RESULT_DIR/fk_without_indexes_insert.txt 2>&1

echo "Analyzing..."
psql -U postgres -c "ANALYZE;"

echo "Running DELETE benchmark (FK WITHOUT INDEXES)"

pgbench -U postgres -c 1 -j 1 -T 180  \
-f tests/fk_delete.sql postgres \
> $RESULT_DIR/fk_without_indexes_delete.txt 2>&1

echo "Cleaning database"

psql -U postgres -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

echo "Initializing pgbench..."

echo "===== WITHOUT FK TEST ====="

psql -U postgres -f schema/schema_without_fk.sql
psql -U postgres -f data/init.sql

echo "Analyzing..."
psql -U postgres -c "ANALYZE;"

echo "Running INSERT benchmark (NO FK)"
pgbench -U postgres -c 20 -j 4 -T 180 \
-f tests/insert_likes.sql postgres \
> $RESULT_DIR/without_fk_insert.txt 2>&1

echo "Analyzing..."
psql -U postgres -c "ANALYZE;"

echo "Running DELETE benchmark (NO FK)"
pgbench -U postgres -c 1 -j 4 -T 180 \
-f tests/without_fk_delete.sql postgres \
> $RESULT_DIR/without_fk_delete.txt 2>&1

echo "Benchmark finished"