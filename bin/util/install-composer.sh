#!/usr/bin/env bash

install_minimal_composer() {

    status "Install minimal composer"

    ### Copied from https://github.com/heroku/heroku-buildpack-php

    # PHP expects to be installed in /app/.heroku/php because of compiled paths, let's set that up!
    mkdir -p /app/.heroku
    # all system packages live in there
    mkdir -p $build_dir/.heroku/php
    # set up Composer
    export COMPOSER_HOME=$cache_dir/.composer
    mkdir -p $COMPOSER_HOME

    # if the build dir is not "/app", we symlink in the .heroku/php subdir (and only that, to avoid problems with other buildpacks) so that PHP correctly finds its INI files etc
    [[ $build_dir == '/app' ]] || ln -s $build_dir/.heroku/php /app/.heroku/php

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
    mkdir -p $build_dir/.heroku/php-min
    ln -s $build_dir/.heroku/php-min /app/.heroku/php-min

    curl_retry_on_18 --fail --silent --location -o $build_dir/.heroku/php-min.tar.gz "${s3_url}php-min-7.3.23.tar.gz"
    tar xzf $build_dir/.heroku/php-min.tar.gz -C $build_dir/.heroku/php-min
    rm $build_dir/.heroku/php-min.tar.gz

    curl_retry_on_18 --fail --silent --location -o $build_dir/.heroku/composer.tar.gz "${s3_url}composer-1.10.13.tar.gz"
    tar xzf $build_dir/.heroku/composer.tar.gz -C $build_dir/.heroku/php

}
