#!/usr/bin/env bash
# shellcheck disable=SC2016

expectSuccess 'Hello World' '
    readarray -t lines <<< "$(manage hello 2>/dev/null)"
    [ "${lines[0]}" = "Hello World!"            ] &&
    [ "${lines[1]}" = "Script name: hello"      ]
'

finish
