#!/usr/bin/env bash
set   +o errexit
set   +o errtrace
set   +o pipefail
shopt -u nullglob
IFS=$' \n\t'

case "${TRAVIS_OS_NAME}" in
    linux)
        ./bin/manage ci
        ;;
    osx)
        brew update
        brew install bash

        /usr/local/bin/bash --version

        /usr/local/bin/bash bin/manage ci
        ;;
    *)
        exit 1
esac
