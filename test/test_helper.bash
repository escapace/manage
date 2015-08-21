#!/usr/bin/env bash
BATS_PARENT_DIRNAME="$( dirname "${BATS_TEST_DIRNAME}" )"
export BATS_PARENT_DIRNAME

import()
{
    local path
    local requirements="$1"
    path="$(cd "${BATS_PARENT_DIRNAME}"/common || exit ; pwd)"
    local OPWD=$PWD ; cd "${path}" || exit
    for file in "${path}"/*
    do
        if [   -f "${file}" ] &&
           [   -r "${file}" ] &&
           [ ! -L "${file}" ] &&
           [[ "$(basename "${file}")" =~ ^[-a-zA-Z]*$ ]]
        then
            for requirement in ${requirements[*]}
            do
                if [[ "${requirement}" == "$(basename "${file}")" ]]
                then
                    source "${file}"
                fi
            done
        fi
    done
    cd "${OPWD}" || exit
}

setup() {
    export TMP="$BATS_TEST_DIRNAME/tmp"
}

fixtures() {
  FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixtures/$1"
  RELATIVE_FIXTURE_ROOT="$(bats_trim_filename "$FIXTURE_ROOT")"
}

# filter_control_sequences() {
#   "$@" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
# }

# teardown() {
#     [ -d "$TMP" ] && rm -f "$TMP"/*
# }
