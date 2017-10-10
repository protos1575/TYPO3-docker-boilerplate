link config in Project Folder

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
