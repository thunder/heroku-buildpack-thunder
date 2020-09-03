#!/usr/bin/env bash

install_sqlite() {

    status "Install sqlite"

    mkdir -p /app/.sqlite
    curl_retry_on_18 --fail --silent --location -o /app/.php/sqlite.tar.gz https://www.sqlite.org/2018/sqlite-autoconf-3260000.tar.gz

    mkdir -p /app/.sqlite/php-min
    tar xzf /app/.sqlite/sqlite.tar.gz -C /app/.sqlite/sqlite

    cd sqlite
    ./configure
    make
    make install
    rm /app/.sqlite/sqlite.tar.gz
    rm -fr /app/.sqlite/sqlite

#echo "Building SQLite…"
#
#
#SOURCE_TARBALL='https://www.sqlite.org/sqlite-autoconf-3070900.tar.gz'
#
#curl $SOURCE_TARBALL | tar xz
## jx
#mv sqlite-autoconf-3070900 sqlite
#
#cd sqlite
#./configure --prefix=$OUT_PREFIX
#make
#make install
#
## Cleanup
#cd ..
#

}
