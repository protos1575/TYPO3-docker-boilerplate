#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"

if [ "$#" -lt 1 ]; then
    echo "No project type defined (either typo3, neos or git)"
    exit 1
fi


rm -rf -- "$CODE_DIR"
mkdir -p "$CODE_DIR"

case "$1" in
    ###################################
    ## TYPO3 CMS
    ###################################
    "typo3")
        execInDir "$CODE_DIR" "docker run --rm --env COMPOSER_CACHE_DIR=/tmp --user $(id -u):$(id -g) -v \$(pwd):/app composer/composer:alpine create-project typo3/cms-base-distribution /app"
        execInDir "$CODE_DIR" "ln -s vendor/bin/typo3cms"
        execInDir "$CODE_DIR" "chmod +x typo3cms"
        execInDir "$CODE_DIR" "docker run --rm --user $(id -u):$(id -g) --net=t3docker_default --link t3docker_mysql_1:mysql -v \$(pwd):/app t3docker_app /bin/bash -c '\
        ./typo3cms install:setup --non-interactive \
        --database-user-name=dev \
        --database-user-password=dev \
        --database-host-name=mysql \
        --database-port=3306 \
        --database-name=typo3 \
        --admin-user-name=dev-admin \
        --admin-password=admin123  \
        --site-name=TYPO3 8x; \
        ./typo3cms extension:activate beuser; \
        ./typo3cms extension:activate scheduler; \
        ./typo3cms extension:activate rte_ckeditor; \
        ./typo3cms extension:activate context_help; \
        ./typo3cms extension:activate viewpage; \
        ./typo3cms extension:activate func; \
        ./typo3cms extension:activate wizard_crpages; \
        ./typo3cms extension:activate wizard_sortpages; \
        ./typo3cms extension:activate info; \
        ./typo3cms extension:activate info_pagetsconfig; \
        ./typo3cms extension:activate tstemplate; \
        ./typo3cms extension:activate fluid_styled_content; \
        ./typo3cms extension:activate cshmanual; \
        ./typo3cms extension:activate documentation; \
        ./typo3cms extension:activate about; \
        ./typo3cms extension:activate t3editor; \
        ./typo3cms extension:activate sys_note; \
        ./typo3cms extension:activate rsaauth; \
        ./typo3cms extension:activate reports; \
        ./typo3cms extension:activate recycler; \
        ./typo3cms extension:activate reports; \
        ./typo3cms extension:activate opendocs; \
        ./typo3cms extension:activate setup; \
        ./typo3cms extension:activate lowlevel; \
        cp vendor/typo3/cms/_.htaccess web/.htaccess; \
        ./typo3cms autocomplete; \
        ./typo3cms database:updateschema \"*.*\"; \
        ./typo3cms cleanup:updatereferenceindex; \
        ./typo3cms cache:flush; \
        echo \"8x ready\"'"
        ;;

    ###################################
    ## TYPO3 NEOS
    ###################################
    "neos")
        execInDir "$CODE_DIR" "docker run --rm --env COMPOSER_CACHE_DIR=/tmp --user $(id -u):$(id -g) -v \$(pwd):/app composer/composer:alpine create-project neos/neos-base-distribution /app"
        echo "\nNOTE: You probably want to change the WEB_DOCUMENT_ROOT env in your etc/environment.yml to '/app/Web/' and run 'docker-composer up -d app' to populate the change."
        ;;

    ###################################
    ## GIT
    ###################################
    "git")
        if [ "$#" -lt 2 ]; then
            echo "Missing git url"
            exit 1
        fi
        git clone --recursive "$2" "$CODE_DIR"
        ;;
esac

touch -- "$CODE_DIR/.gitkeep"
