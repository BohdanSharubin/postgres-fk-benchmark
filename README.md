# PostgreSQL Foreign Key Performance Benchmark

## Overview

This project benchmarks the performance impact of **foreign key constraints (FK)** in PostgreSQL, focusing on **INSERT** and **DELETE** operations.

The goal is simple:

> Measure how much foreign keys affect write performance under load.

The benchmark compares two scenarios:

* Schema **with foreign keys**
* Schema **without foreign keys**

---

## Project Structure

```
.
├── schema/
│   ├── schema_fk.sql
│   └── schema_without_fk.sql
│
├── data/
│   └── init.sql
│
├── tests/
│   ├── insert_likes.sql
│   ├── fk_delete.sql
│   └── without_fk_delete.sql
│
├── results/
│   └── (generated after run)
│
├── run.sh
└── Dockerfile
```

---

## How It Works

The benchmark runs a sequence of tests:

### 1. Database initialization

* PostgreSQL starts inside a Docker container
* Schema is created (with or without FK)
* Test data is inserted

### 2. INSERT benchmark

Simulates concurrent inserts into a many-to-many table (`users_likes`).

### 3. DELETE benchmark

Simulates deletion of users and related records.

### 4. Repeat without foreign keys

Each test runs for a fixed duration using `pgbench`.

---

## Benchmark Scenarios

### With Foreign Keys

* Referential integrity enforced
* Additional checks on INSERT / DELETE

### Without Foreign Keys

* No integrity checks
* Maximum raw performance

---

## Parameters

The following `pgbench` parameters are used:

| Parameter | Value  | Description                                |
| --------- | ------ | ------------------------------------------ |
| `-c`      | 20     | Number of clients (concurrent connections) |
| `-j`      | 4      | Worker threads                             |
| `-T`      | 60     | Test duration (seconds)                    |
| `-f`      | script | SQL script to execute                      |

For DELETE tests:

* FK and Non-FK version uses `-c 1` to avoid constraint conflicts

---

## Running the Benchmark

### Requirements

* Docker installed

---

## Run (All Platforms)

### macOS / Linux

```bash
docker build -t pg-fk-benchmark .

docker run --rm \
  -v $(pwd)/results:/benchmark/results \
  pg-fk-benchmark
```

---

### Windows (PowerShell)

```powershell
docker build -t pg-fk-benchmark .

docker run --rm `
  -v ${PWD}\results:/benchmark/results `
  pg-fk-benchmark
```

---

### Windows (CMD)

```cmd
docker build -t pg-fk-benchmark

docker run --rm ^
  -v %cd%\results:/benchmark/results ^
  pg-fk-benchmark
```

---

## Output

Benchmark results are saved as text files:

```
results/
├── fk_insert.txt
├── fk_delete.txt
├── without_fk_insert.txt
└── without_fk_delete.txt
```

Each file contains:

* transactions processed
* latency (average)
* TPS (transactions per second)

---

## Example Results

| Test           | Latency              | TPS    |
| -------------- | -------------------- | ------ |
| INSERT (FK)    | higher               | lower  |
| INSERT (NO FK) | lower                | higher |
| DELETE (FK)    | significantly higher | lower  |
| DELETE (NO FK) | much faster          | higher |

In some cases, DELETE with FK can be **10–20× slower**, especially without proper indexing.

---

## Important Notes

### Indexes Matter

Foreign keys **do not automatically create indexes** on referencing columns.

Without indexes:

* DELETE and UPDATE operations can become extremely slow

Recommended:

```sql
CREATE INDEX idx_users_likes_user_id ON users_likes(user_id);
```

---

### Concurrency and Constraints

High concurrency + foreign keys may cause:

* lock contention
* constraint violations

That’s why DELETE tests with FK use a single client.

---

## Conclusion

Foreign keys provide **data integrity**, but they come with a cost:

* Minimal overhead for INSERT (with proper indexing)
* Potentially large overhead for DELETE and UPDATE

This benchmark helps visualize that trade-off in a controlled environment.

---

## License

MIT
