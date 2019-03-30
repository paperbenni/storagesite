#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

pb install/install.sh

if ! surge --version >/dev/null; then
    if ! npm --version >/dev/null; then
        echo "nodejs and npm are required"
        pinstall nodejs npm
    fi
    echo "installing surge"
    sudo npm install -g surge
    surge login
fi

if ! [ -e surge.config ]; then
    dialog --inputbox "Enter the site name:" 8 40 2>surge.config
fi

SURGE=$(cat surge.config)
echo "please make sure that $SURGE.surge.sh doesnt already exist. If it is a taken domain, delete surge.config and start again"
rm surge.config
rm index.html
curl https://raw.githubusercontent.com/paperbenni/storagesite/master/apindex | python3 /dev/stdin .
#actually run surge
surge . "$SURGE.surge.sh"
echo ''
echo "$SURGE" >surge.config
echo "site published at $SURGE.surge.sh"
