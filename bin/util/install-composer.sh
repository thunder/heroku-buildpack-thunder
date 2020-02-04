#!/usr/bin/env bash

install_minimal_composer() {

    status "Install minimal composer"

    # Copied from https://github.com/heroku/heroku-buildpack-php
    s3_url="https://lang-php.s3.amazonaws.com/dist-${STACK}-stable/"

    mkdir -p /app/.php
    curl_retry_on_18 --fail --silent --location -o /app/.php/php-min.tar.gz "${s3_url}php-min-7.3.14.tar.gz"
    mkdir -p /app/.php/php-min
    tar xzf /app/.php/php-min.tar.gz -C /app/.php/php-min
    rm /app/.php/php-min.tar.gz


    curl_retry_on_18 --fail --silent --location -o /app/.php/composer.tar.gz "${s3_url}composer-1.9.2.tar.gz"
    mkdir -p /app/.php/php
    tar xzf /app/.php/composer.tar.gz -C /app/.php/php
    rm /app/.php/composer.tar.gz

}
