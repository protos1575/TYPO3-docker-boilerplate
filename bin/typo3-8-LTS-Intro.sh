#!/usr/bin/env bash

echo '
{
    "repositories": [
        {
            "type": "composer",
            "url": "https://composer.typo3.org"
        }
    ],
    "config": {
        "bin-dir": "bin"
    },
    "require": {
        "typo3/cms": "^8.7",
        "helhum/typo3-console": "^4.8",
        "typo3-ter/introduction": "^3.0",
        "typo3-ter/realurl": "^2.2"
    },
    "extra": {
        "typo3/cms": {
            "cms-package-dir": "{$vendor-dir}/typo3/cms",
            "web-dir": "web"
        },
        "helhum/typo3-console": {
            "install-extension-dummy": false
        }
    }
}
' > composer.json

composer install -o --no-interaction

## for typo3-console
chmod +x bin/*
cp vendor/typo3/cms/_.htaccess web/.htaccess

bin/typo3cms install:setup \
    --non-interactive \
    --force \
    --use-existing-database \
    --database-user-name="dev" \
    --database-user-password="dev" \
    --database-host-name="mysql" \
    --database-port="3306" \
    --database-name="typo3" \
    --admin-user-name="dev-admin" \
    --admin-password="admin123" \
    --site-name="TYPO3 LTS"

bin/typo3cms extension:activate bootstrap_package
bin/typo3cms extension:activate introduction
bin/typo3cms extension:activate realurl

bin/typo3cms install:generatepackagestates --activate-default=true
bin/typo3cms install:fixfolderstructure
bin/typo3cms install:extensionsetupifpossible

bin/typo3cms autocomplete

bin/typo3cms database:updateschema '*.*'
bin/typo3cms cleanup:updatereferenceindex
bin/typo3cms cache:flush




echo "typo3 ready"
