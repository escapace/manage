#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090,SC2034

source "${MANAGE_DIRECTORY}/manage"
FIXTURES="${SHARNESS_TEST_DIRECTORY}/fixtures"

MANAGE_UNDERSCORE \
    path/commonPath \
    path/commonTail \
    path/relativePath \
    path/absolutePath

MANAGE_BOOTSTRAP

expectSuccess "commonPath" '
    expected="/foo/bar"
    result="$(_ commonPath "/foo/bar/baz" "/foo/bar/qwe")"
    [ "$result" = "${expected}" ]
'

expectSuccess "commonTail" '
    expected="bar/baz"
    result="$(_ commonTail "/qwe/bar/baz" "/asd/bar/baz")"
    [ "$result" = "${expected}" ]
'

expectSuccess "absolutePath" '
    cd "${MANAGE_DIRECTORY}"
    result="$(_ absolutePath test/fixtures)"
    [ "$result" = "${FIXTURES}" ]
'
expectSuccess "relativePath" '
    result="$(_ relativePath "${FIXTURES}" "${MANAGE_DIRECTORY}")"
    [ "$result" = "test/fixtures" ]
'

finish
