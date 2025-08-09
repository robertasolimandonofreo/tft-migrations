#!/bin/sh
set -e

echo "=== DEBUG INFO ==="
echo "POSTGRES_HOST: $POSTGRES_HOST"
echo "POSTGRES_PORT: $POSTGRES_PORT"
echo "POSTGRES_USER: $POSTGRES_USER"
echo "POSTGRES_DB: $POSTGRES_DB"

echo "=== TESTING CONNECTIVITY ==="
ping -c 3 postgres || echo "Ping failed"
nc -zv postgres 5432 || echo "Port test failed"

echo "=== TESTING DATABASE CONNECTION ==="
DATABASE_URL="postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?sslmode=$POSTGRES_SSL_MODE"
echo "DATABASE_URL: $DATABASE_URL"

psql "$DATABASE_URL" -c "SELECT version();" || echo "Database connection failed"

echo "=== RUNNING MIGRATIONS ==="
migrate -path /migrations -database "$DATABASE_URL" up