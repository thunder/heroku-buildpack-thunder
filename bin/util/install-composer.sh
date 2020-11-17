#!/usr/bin/env bash

install_minimal_composer() {

    echo "-----> Install minimal composer"

    ### Copied from https://github.com/heroku/heroku-buildpack-php

    # PHP expects to be installed in /app/.php/php because of compiled paths, let's set that up!
    mkdir -p /app/.php
    # all system packages live in there
    mkdir -p /app/.php/php
    mkdir -p /app/.php/php/bin

    # set up Composer
    export COMPOSER_HOME=$cache_dir/.composer
    mkdir -p $COMPOSER_HOME

    s3_url="https://lang-php.s3.amazonaws.com/dist-${STACK}-stable/"
    # prepend the default repo to the list configured by the user
    # list of repositories to use is in ascening order of precedence
    export_env_dir "$env_dir" '^HEROKU_PHP_PLATFORM_REPOSITORIES$'
    HEROKU_PHP_PLATFORM_REPOSITORIES="${s3_url} ${HEROKU_PHP_PLATFORM_REPOSITORIES:-}"
    if [[ "${HEROKU_PHP_PLATFORM_REPOSITORIES}" == *" - "* ]]; then
      # a single "-" in the user supplied string removes everything to the left of it; can be used to delete the default repo
      echo "Default platform repository disabled."
      HEROKU_PHP_PLATFORM_REPOSITORIES=${HEROKU_PHP_PLATFORM_REPOSITORIES#*" - "}
      s3_url=$(echo "$HEROKU_PHP_PLATFORM_REPOSITORIES" | cut -f1 -d" " | sed 's/[^/]*$//')
      echo "Bootstrapping using ${s3_url}..."
    fi

    # minimal PHP needed for installs, and make "composer" invocations use that for now
    mkdir -p /app/.php/php-min

    curl_retry_on_18 --fail --silent --location -o /app/.php/php-min.tar.gz "${s3_url}php-min-7.3.23.tar.gz"
    tar xzf /app/.php/php-min.tar.gz -C /app/.php/php-min
    rm /app/.php/php-min.tar.gz

    curl_retry_on_18 --fail --silent --location -o /app/.php/php/bin/composer "https://getcomposer.org/composer-stable.phar"

}
