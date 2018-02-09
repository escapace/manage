#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090,SC2034

source "${MANAGE_DIRECTORY}/manage"
FIXTURES="${SHARNESS_TEST_DIRECTORY}/fixtures"

MANAGE_UNDERSCORE \
    lang/execute \
    lang/executeIn \
    lang/exists \
    lang/first \
    lang/named \
    lang/repeat \
    lang/required \
    lang/retry \
    lang/truth \
    lang/truthEcho \
    lang/truthValue

MANAGE_BOOTSTRAP

expectSuccess 'first' '
    a=""
    b="asd"
    result="$(_ first "$a" "$b")"
    [ "$result" = "asd" ]
'

expectSuccess 'named' '
    some_var="The value I really want"
    result="$(_ named "some_var")"
    [ "$result" = "The value I really want" ]
'

expectSuccess 'truth' '
    _ truth True          && #==> true
    _ truth 1             && #==> true
    _ truth on            && #==> true
    mustFail _ truth spam && #==> false
    mustFail _ truth false && #==> false
    mustFail _ truth #==> false
'

expectSuccess 'truthEcho' '
    resultA="$(_ truthEcho true "first" "second")"
    resultB="$(_ truthEcho false "first" "second")"
    [ "$resultA" = "first" ] &&
    [ "$resultB" = "second" ]
'

expectSuccess 'truthValue' '
    resultA="$(_ truthValue true)"
    resultB="$(_ truthValue false)"
    [ "$resultA" = "1" ] &&
    [ "$resultB" = "0" ]
'

expectSuccess 'repeat' '
    result="$(_ repeat 3 echo -n asd )"
    [ "$result" = "asdasdasd" ]
'

expectSuccess 'required' '
    qwe="qwe"
    space=" "
    bsd=""

    _ required "${qwe}" &&
    mustFail _ required "${asd}" &&
    mustFail _ required "${space}" &&
    mustFail _ required "${bsd}" &&
    mustFail _ required "${qwe}" "${asd}" &&
    mustFail _ required "${asd}" "${qwe}"
'

expectSuccess 'exists' '
    arrayTrue=("bash" "mkdir" "ls" "rm" "cat")
    arrayFalse=("bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln")
    result="$(_ exists "${arrayFalse[@]}" || echo "${arrayFalse[$(($?-1))]}")"

    _ exists &&
    _ exists "bash" "mkdir" "ls" "rm" "cat" &&
    expectCode 6 _ exists "bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln" &&
    expectCode 2 _ exists "bash" "qweasd" &&
    expectCode 1 _ exists "qweasd" "bash" &&
    _ exists "${arrayTrue[@]}" &&
    expectCode 6 _ exists "${arrayFalse[@]}" &&
    [ "$result" = "6e8fe0f63ffbb20d6d202d5520f5051c" ]
'

expectSuccess 'execute' '
    script="${FIXTURES}/execute/hello"
    result="$(_ execute "${script}")"
    [ "$result" = "Hello World" ]
'

expectSuccess 'executeIn' '
    script="${FIXTURES}/execute/pwd"
    result="$(_ executeIn "${FIXTURES}" "${script}")"

    [[ "$(pwd)" != "${FIXTURES}" ]] &&
    [ "$result" = "${FIXTURES}" ]
'

try=0

flakyFunction () {
    try=$((try + 1))

    if [[ "${try}" = 7 ]]
    then
        echo "done "${try}
    else
        return 1
    fi
}

expectSuccess 'retry' '
    result="$(_ retry 10 flakyFunction arg1 arg2)"

    [ "$result" = "done 7" ]
'

finish
