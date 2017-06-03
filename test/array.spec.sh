#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090

source "${MANAGEDIRECTORY}/bin/manage"

MANAGE_UNDERSCORE \
    array/complement \
    array/difference \
    array/forEach \
    array/includes \
    array/indexOf \
    array/intersection \
    array/join \
    array/union

MANAGE_BOOTSTRAP

expectSuccess "join" '
    arr=("a sd" "qwe" "z xc")
    expected="a sd|qwe|z xc"
    result="$(_ join arr "|")"
    [ "${result}" = "${expected}" ]
'

expectSuccess "includes" '
    aa=("a sd" "q we" "z xc")
    _ includes aa fgh || true
    _ includes aa "q we"
    mustFail _ includes aa "q"
'

expectSuccess "indexOf" '
    aa=("asd" "qwe" "zx c")
    result="$(_ indexOf aa "zx c")"
    expected="2"
    [ "$result" = "${expected}" ]
'

expectSuccess "forEach" '
expected="asd 0 bla
qwe 1 bla
zx c 2 bla"

    aa=("asd" "qwe" "zx c")
    result="$(_ forEach aa echo bla)"
    [ "$result" = "${expected}" ]
'


expectSuccess "intersection" '
    aa=("asd" "q we" "zxc" "bb b")
    ab=("asdd" "q we" "z xcc" "bb b")
    result="$(_ intersection aa ab "|")"
    expected="q we|bb b"
    [ "$result" = "${expected}" ]
'

expectSuccess "difference" '
    aa=("asd" "q we" "zx c" "bb b")
    ab=("asd" "q we" "zxc" "bb b b")
    result="$(_ difference aa ab "|")"
    expected="zx c|bb b"
    [ "$result" = "${expected}" ]
'

expectSuccess "complement" '
    aa=("asd" "q we" "zx c" "bb b")
    ab=("asd" "q we" "zxc" "bb b b")
    result="$(_ complement aa ab "|")"
    expected="zx c|bb b|zxc|bb b b"
    [ "$result" = "${expected}" ]
'

expectSuccess "union" '
    aa=("a" "b" "c" "d")
    ab=("e" "f" "g space" "h")
    result="$(_ union aa ab "|")"
    expected="a|b|c|d|e|f|g space|h"
    [ "$result" = "${expected}" ]
'

finish
