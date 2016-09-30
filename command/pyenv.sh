#!/usr/bin/env bash
# Usage: pyenv.sh <Python Version Number>

global() {
    pyenv rehash
    pyenv global $VERSION
}

install() {
    pyenv install $VERSION
    pyenv rehash
    pyenv global $VERSION
}

if [ $# != 1 ]; then
    echo "[Error]: Not Found Python version"
    echo "[Info]: Usage: pyenv.sh <Python Version Number>"
    exit 1
fi

VERSION=$1

if [ -e /home/vagrant/.pyenv/versions/$VERSION ]; then
    global
else
    install
fi
