#!/bin/sh
# Usage: rbenv.sh <Ruby Version Number>

global() {
    rbenv rehash
    rbenv global $VERSION
}

install() {
    rbenv install $VERSION
    rbenv rehash
    rbenv global $VERSION
}

if [ $# != 1 ]; then
    echo "[Error]: Not Found Ruby version"
    echo "[Info]: Usage: rbenv.sh <Ruby Version Number>"
    exit 1
fi

VERSION=$1

if [ -e /home/vagrant/.rbenv/versions/$VERSION ]; then
    global
else
    install
fi
