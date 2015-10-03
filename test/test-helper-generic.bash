#!/usr/bin/env bash
BATS_PARENT_DIRNAME="$( dirname "${BATS_TEST_DIRNAME}" )"
export BATS_PARENT_DIRNAME

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

filter_control_sequences() {
  "$@" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
}

