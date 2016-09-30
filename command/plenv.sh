#!/usr/bin/env bash
# Usage: plenv.sh <Perl Version Number>

global() {
    plenv rehash
    plenv global $VERSION
}

install() {
    plenv install $VERSION
    plenv rehash
    plenv global $VERSION
    plenv install-cpanm
    cpanm Carton
}

if [ $# != 1 ]; then
    echo "[Error]: Not Found Perl version"
    echo "[Info]: Usage: plenv.sh <Perl Version Number>"
    exit 1
fi

VERSION=$1

if [ -e /home/vagrant/.plenv/versions/$VERSION ]; then
    global
else
    install
fi
