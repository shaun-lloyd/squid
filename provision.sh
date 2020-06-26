#!/usr/bin/env bash

set -e
set -x

function ssl_cert_create() {
    mkdir -m 700 -p "${KEY_PATH}" && cd ${KEY_PATH}

    # Create Self-Signed Root CA Certificate
    openssl req -new -newkey rsa:2048 -sha256 \
        -nodes -x509 -extensions v3_ca \
        -subj "/C=${KEY_COUNTRY}/ST=${KEY_STATE}/L=${KEY_LOCALITY}/O=${KEY_ORG}/CN=${KEY_FQDN}" \
        -days "${KEY_DAYS}" \
        -keyout "${KEY_FILE}.pem" \
        -out "${KEY_FILE}.pem"

    # Create a DER-encoded certificate for users
    openssl x509 \
        -outform DER \
        -in "${KEY_FILE}.pem" \
        --out "${KEY_FILE}.der"
}

function ssl_cache_init() {
    # Initialize SSL database for storing cached certificates.
    security_file_certgen -c -s /app/var/logs/ssl_db -M 4MB
}

function logs_create() {
    touch /app/var/logs/{cache,store,access}.log
    chmod 660 /app/var/logs/*.log
}

function cache_create() {
    mkdir -p -m 770 /app/cache
}

function cache_init() {
    squid -Nz
}

logs_create
[ ! -d '/app/etc/ssl_cert' ] && ssl_cert_create
[ ! -d '/app/var/logs/ssl_db' ] && ssl_cache_init
[ ! -d '/app/cache' ] && cache_create
chown root:proxy /app -R
[ ! -d '/app/cache/00' ] && cache_init

