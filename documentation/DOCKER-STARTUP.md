[<-- Back to main section](../README.md)

# First startup

## Create project

Checkout this project and create and run the Docker containers using [docker-compose](https://github.com/docker/compose):

```bash
git clone https://github.com/webdevops/TYPO3-docker-boilerplate.git projectname
cd projectname

# copy favorite docker-compose.*.yml to docker-compose.yml
cp docker-compose.development.yml docker-compose.yml

docker-compose up -d or make up
```

Now create your project inside the docker boilerplate:

- [Create new TYPO3 project](PROJECT-TYPO3.md)
- [Create new NEOS project](PROJECT-NEOS.md)
- [Running any other php based project](PROJECT-OTHER.md)
- [Running existing project](PROJECT-EXISTING.md)

For an existing project just put your files into `app/` folder or use git to clone your project into `app/`.

## Advanced usage (git)

Use this boilerplate as template and customize it for each project. Put this Docker
configuration for each project into separate git repositories.

Now set your existing project repository to be a git submodule in `app/`.
Every developer now needs only to clone the Docker repository with `--recursive` option
to get both, the Docker configuration and the TYPO3 installation.

For better usability track a whole branch (eg. develop or master) as submodule and not just a single commit. [This requires git v1.8.2+](https://git.kernel.org/cgit/git/git.git/tree/Documentation/RelNotes/1.8.2.txt?id=v1.8.2#n186).

## XDEBUG for mac configuration

The problem with Docker for Mac and xDebug is that it is mapped to your localhost (127.0.0.1), so PHP/xDebug doesn’t actually know the true IP address of the remote host connecting to xdebug. To get around this what we need to do is configure an alias to the loopback device to get this work.

```bash
sudo ifconfig lo0 alias 10.254.254.254
```

to remove the maped alias

```bash
sudo ifconfig lo0 -alias 10.254.254.254
```

To persist the loopback address, you can create a plist, which will be loaded automatically when you boot your mac:

Filename: /Library/LaunchDaemons/com.protos1575.docker_10254_alias.plist

```bash
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.protos1575.docker_10254_alias</string>
    <key>ProgramArguments</key>
    <array>
        <string>/sbin/ifconfig</string>
        <string>lo0</string>
        <string>alias</string>
        <string>10.254.254.254</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```
To run this straightaway (without a reboot) run the following:

```bash
sudo launchctl load /Library/LaunchDaemons/com.protos1575.docker_10254_alias.plist
```

to remove

```bash
sudo launchctl unload /Library/LaunchDaemons/com.protos1575.docker_10254_alias.plist
```

In your PhpStorm configuration: go to PhpStorm => Settings => Languages & Frameworks => PHP => Debug => DBGp Proxy and set Host to the IP 10.254.254.254 and Port 9001


Thanks to https://www.ashsmith.io/docker/get-xdebug-working-with-docker-for-mac/ and https://blog.felipe-alfaro.com/2017/03/22/persistent-loopback-interfaces-in-mac-os-x/
