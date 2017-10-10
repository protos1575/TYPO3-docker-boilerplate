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
        "php": ">=7.0.0 <7.2",
        "typo3/cms": "dev-master"
    },
    "require-dev": {
    },
    "extra": {
        "typo3/cms": {
            "cms-package-dir": "{$vendor-dir}/typo3/cms",
            "web-dir": "web"
        }
    }
}
' > composer.json

composer install -o --no-interaction

## for typo3-console
chmod +x bin/*
cp vendor/typo3/cms/_.htaccess web/.htaccess

touch FIRST_INSTALL


echo "typo3 ready, go to localhost:8000"
