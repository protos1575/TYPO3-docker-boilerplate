## link config in Project Folder

```
ln -s docker-compose.development.yml docker-compose.yml
ln -s docker-compose.production.yml docker-compose.yml
rm docker-compose.yml
```
## SSH
!!! id_*** DEIN ssh_key  

```
ssh-copy-id -i ~/.ssh/id_***.pub -p10022 application@localhost
```

Passwort: dev  

~.ssh/config  Eintrag hinzufügen

```
Host docker_typo3  
    HostName localhost  
    User application
    IdentityFile ~/.ssh/id_***
    ForwardAgent yes
    Port 10022
```
### composer example

```
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
        "typo3/cms": "^8.7",
        "helhum/typo3-console": "^5.0",
        "typo3-ter/introduction": "^3.0",
        "typo3-ter/unroll": "^2.0",
        "typo3-ter/realurl": "^2.3"
    },
    "extra": {
        "typo3/cms": {
            "cms-package-dir": "{$vendor-dir}/typo3/cms",
            "web-dir": "web"
        }
    }
}
' > composer.json

composer install -o --no-interaction --no-dev
```

### DB Settings for 8.x
```
'DB' => [
        'Connections' => [
            'Default' => [
                'charset' => 'utf8',
                'dbname' => 'typo3',
                'driver' => 'mysqli',
                'host' => 'mysql',
                'password' => 'dev',
                'port' => 3306,
                'user' => 'dev',
            ],
        ],
    ],
```

### usefull commands

```
chmod +x bin/*
cp vendor/typo3/cms/_.htaccess web/.htaccess

touch web/FIRST_INSTALL

./bin/typo3cms extension:activate introduction

./bin/typo3cms install:fixfolderstructure
./bin/typo3cms database:updateschema '*.*'
./bin/typo3cms cleanup:updatereferenceindex
./bin/typo3cms cache:flush

```
