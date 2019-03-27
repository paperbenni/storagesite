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

if [ -e surge.config ]; then
    SURGE=$(cat surge.config)
else
    echo "what name should the website have?"
    read surgename
    SURGE="$surgename"
    echo "please make sure that $SURGE.surge.sh doesnt already exist. If it is a taken domain, delete surge.config and start again"
    echo "$SURGE" >surge.config
fi

find -type f >list.txt

wget https://raw.githubusercontent.com/paperbenni/storagesite/master/index.html

while read p; do
    if [ "$p" = "surge.config" ] || [ "$p" = "index.html" ]; then
        continue
    fi
    FILENAME=${p#./}
    echo "<a href=\"$FILENAME\">$FILENAME</a>" >>index.html
done <list.txt

https://raw.githubusercontent.com/paperbenni/storagesite/master/apindex >apindex
chmod +x apindex
./apindex
rm apindex
#actually run surge
surge . "$SURGE".surge.sh
echo "site published at $SURGE.surge.sh"
