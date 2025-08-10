FROM alpine:3.20
WORKDIR /migrations

RUN apk add --no-cache wget ca-certificates tar postgresql-client netcat-openbsd && \
    wget -O migrate.tar.gz https://github.com/golang-migrate/migrate/releases/download/v4.16.2/migrate.linux-amd64.tar.gz && \
    tar -xzf migrate.tar.gz -C /usr/local/bin && \
    rm migrate.tar.gz && \
    chmod +x /usr/local/bin/migrate

COPY entrypoint.sh /migrations/entrypoint.sh
RUN chmod +x /migrations/entrypoint.sh

COPY *.sql /migrations

ENTRYPOINT ["/migrations/entrypoint.sh"]