#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090

source "${MANAGEDIRECTORY}/bin/manage"

MANAGE_UNDERSCORE array/join
MANAGE_BOOTSTRAP

expectSuccess "join" '
    arr=("a sd" "qwe" "z xc")
    expected="a sd|qwe|z xc"
    result="$(_ join arr "|")"
    [ "${result}" = "${expected}" ]
'

finish
