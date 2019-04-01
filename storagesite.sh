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

touch surge.config
if ! [ -e surge.config ]; then
    while test -z $(cat surge.config); do

        dialog --inputbox "Enter the site name:" 8 40 2>surge.config
    done
fi

SURGE=$(cat surge.config)
echo "please make sure that $SURGE.surge.sh doesnt already exist. If it is a taken domain, delete surge.config and start again"
if ! command -v apindex; then
    (
        command -v cmake
        command -v git
    ) || (echo "please install git and cmake" && exit 1)
    git clone --depth=1 https://github.com/libthinkpad/apindex.git
    cd apindex
    cmake . -DCMAKE_INSTALL_PREFIX=/usr
    sudo make install
    cd ..
    rm -rf apindex
fi

apindex .

#actually run surge
surge . "$SURGE.surge.sh"
echo ''
echo "$SURGE" >surge.config
echo "site published at $SURGE.surge.sh"
