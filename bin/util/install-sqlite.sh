#!/usr/bin/env bash

install_sqlite() {

    status "Install sqlite"

    mkdir -p /app/.sqlite
    curl_retry_on_18 --fail --silent --location -o /app/.sqlite/sqlite.tar.gz https://www.sqlite.org/2018/sqlite-autoconf-3260000.tar.gz

    mkdir -p /app/.sqlite/sqlite
    tar xzf /app/.sqlite/sqlite.tar.gz --strip-components 1 -C /app/.sqlite/sqlite

    /app/.sqlite/sqlite/configure --prefix=/app/.sqlite >/dev/null 2>&1
    make -C /app/.sqlite/sqlite
    make install -C /app/.sqlite/sqlite
    rm /app/.sqlite/sqlite.tar.gz
    rm -fr /app/.sqlite/sqlite
    ls /app/.sqlite

}
