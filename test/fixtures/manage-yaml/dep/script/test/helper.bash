#!/usr/bin/env bash

manage () {
    "${MANAGEDIRECTORY}/libexec/manage" "${MANAGEREPOSITORY}" "$@"
}

setup() {
    export TMP="$BATS_TMPDIR/_manage"
    [ -d "${TMP}" ] ||
    mkdir -p "${TMP}"
}

teardown() {
    [ -d "${TMP}" ] &&
    rm -rf "${TMP:?}"
}

fixtures() {
  FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixtures/$1"
  RELATIVE_FIXTURE_ROOT="$(bats_trim_filename "$FIXTURE_ROOT")"
}

