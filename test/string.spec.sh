#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090,SC2034

source "${MANAGE_DIRECTORY}/bin/manage"
FIXTURES="${SHARNESS_TEST_DIRECTORY}/fixtures"

MANAGE_UNDERSCORE string/camelCase \
    string/capitalize \
    string/commonPrefix \
    string/commonSuffix \
    string/createPadding \
    string/endsWith \
    string/lower \
    string/lowerCase \
    string/padEnd \
    string/padStart \
    string/replace \
    string/snakeCase \
    string/splitString \
    string/squeeze \
    string/squeezeLines \
    string/startsWith \
    string/trim \
    string/lowerFirst \
    string/upperFirst \
    string/trimEnd \
    string/trimLines \
    string/trimStart \
    string/upper \
    string/upperCase \
    string/words \
    string/wrap

MANAGE_BOOTSTRAP

expectSuccess "lowerFirst" '
    [[ "$(_ lowerFirst "Hello World")" = "hello World" ]]
'

expectSuccess "upperFirst" '
    [[ "$(_ upperFirst "hello World")" = "Hello World" ]]
'

expectSuccess "words" '
    [[ "$(_ words "camel_case")" = "camel case" ]] &&
    [[ "$(_ words "Camel Case")" = "Camel Case" ]] &&
    [[ "$(_ words "__FOO_BAR__ --foo-bar--")" = "FOO BAR foo bar" ]] &&
    [[ "$(_ words "Also_Foo__Bar")" = "Also Foo Bar" ]] &&
    [[ "$(_ words "Hello-World World-Order!")" = "Hello World World Order" ]]
'

expectSuccess "lowerCase" '
    [[ "$(_ lowerCase "camel_case")" = "camel case" ]] &&
    [[ "$(_ lowerCase "Camel Case")" = "camel case" ]] &&
    [[ "$(_ lowerCase "__FOO_BAR__ --foo-bar--")" = "foo bar foo bar" ]] &&
    [[ "$(_ lowerCase "Also_Foo__Bar")" = "also foo bar" ]] &&
    [[ "$(_ lowerCase "Hello-World World-Order!")" = "hello world world order" ]]
'

expectSuccess "upperCase" '
    [[ "$(_ upperCase "camel_case")" = "CAMEL CASE" ]] &&
    [[ "$(_ upperCase "Camel Case")" = "CAMEL CASE" ]] &&
    [[ "$(_ upperCase "__FOO_BAR__ --foo-bar--")" = "FOO BAR FOO BAR" ]] &&
    [[ "$(_ upperCase "Also_Foo__Bar")" = "ALSO FOO BAR" ]] &&
    [[ "$(_ upperCase "Hello-World World-Order!")" = "HELLO WORLD WORLD ORDER" ]]
'

expectSuccess "camelCase" '
    [[ "$(_ camelCase "camel_case")" = "camelCase" ]] &&
    [[ "$(_ camelCase "camel case")" = "camelCase" ]] &&
    [[ "$(_ camelCase "camel" "case")" = "camelCase" ]] &&
    [[ "$(_ camelCase "Hello-World" "World-Order" "!")" = "helloWorldWorldOrder" ]] &&
    [[ "$(_ camelCase "__FOO_BAR__" "--foo-bar--")" = "fooBarFooBar" ]] &&
    [[ "$(_ camelCase "Also_Foo_" "_Bar")" = "alsoFooBar" ]]
'
expectSuccess "snakeCase" '
    [[ "$(_ snakeCase "snakeCase")" = "snake_case" ]] &&
    [[ "$(_ snakeCase "snake Case")" = "snake_case" ]] &&
    [[ "$(_ snakeCase "SnakeCase")" = "snake_case" ]] &&
    [[ "$(_ snakeCase "SNAKE-case")" = "snake_case" ]] &&
    [[ "$(_ snakeCase "Also_Foo_" "_Bar")" = "also_foo_bar" ]] &&
    [[ "$(_ snakeCase "__FOO_BAR__" "--foo-bar--")" = "foo_bar_foo_bar" ]] &&
    [[ "$(_ snakeCase "Hello-World" "World-Order" "!")" = "hello_world_world_order" ]]
'

expectSuccess "lower" '
    [[ "$(_ lower "Hello" "World")" = "hello world" ]]
'

expectSuccess "upper" '
    [[ "$(_ upper "Hello" "World")" = "HELLO WORLD" ]]
'

expectSuccess "capitalize" '
    [[ "$(_ capitalize "FRED")" = "Fred" ]] &&
    [[ "$(_ capitalize "Hello" "World")" = "Hello world" ]]
'

expectSuccess "trimEnd" '
    [[ "$(_ trimEnd " FRED  ")" = " FRED" ]]
'

expectSuccess "trimStart" '
    [[ "$(_ trimStart " FRED ")" = "FRED " ]]
'

expectSuccess "trim" '
    [[ "$(_ trimStart "FRED")" = "FRED" ]]
'
expectSuccess "squeeze" '
    result="$(_ squeeze "  foo  bar   baz  ")"
    [ "$result" = "foo bar baz" ]
'
expectSuccess "commonPrefix" '
    string="$(echo -e "spam\nspace")"
    result="$(_ commonPrefix "${string}")"
    [ "$result" = "spa" ]
'

expectSuccess "commonSuffix" '
    string="$(echo -e "foobar\nbabar")"
    result="$(_ commonSuffix "${string}")"
    [ "$result" = "bar" ]
'

expectSuccess "commonPrefix stdin" '
    result="$(echo -e "spam\nspace"   | _ commonPrefix)"
    [ "$result" = "spa" ]
'

expectSuccess "commonSuffix stdin" '
    result="$(echo -e "foobar\nbabar" | _ commonSuffix)"
    [ "$result" = "bar" ]
'

expectSuccess "commonSuffix stdin" '
    result="$(echo -e "foobar\nbabar" | _ commonSuffix)"
    [ "$result" = "bar" ]
'

expectSuccess 'createPadding' '
    [[ "$(_ createPadding 10 "-!-")" = "-!--!--!--" ]]
'
expectSuccess 'padStart' '
    string="The string to pad."
    [[ "$(_ padStart "${string}" "21" "-!-")" = "-!-${string}"  ]] &&
    [[ "$(_ padStart "${string}" "22" "-!-")" = "-!--${string}"  ]] &&
    [[ "$(_ padStart "${string}" "23" "-!-")" = "-!--!${string}"  ]] &&
    [[ "$(_ padStart "${string}" "24" "-!-")" = "-!--!-${string}"  ]]
'

expectSuccess 'padEnd' '
    string="The string to pad."
    [[ "$(_ padEnd "${string}" "21" "-!-")" = "${string}-!-"  ]] &&
    [[ "$(_ padEnd "${string}" "22" "-!-")" = "${string}-!--"  ]] &&
    [[ "$(_ padEnd "${string}" "23" "-!-")" = "${string}-!--!"  ]] &&
    [[ "$(_ padEnd "${string}" "24" "-!-")" = "${string}-!--!-"  ]]
'

expectSuccess 'startsWith' '
    _ startsWith "Hello World" "Hello World" &&
    _ startsWith "Hello World" "Hello" &&
    _ startsWith "Hello World" "Hel" &&
    _ startsWith "/[a-zA-Z]/" "/" &&
    mustFail _ startsWith "Hello World" "Hello World " &&
    mustFail _ startsWith "Hello World" "hello" &&
    mustFail _ startsWith "Hello World" ""
'

expectSuccess 'endsWith' '
    _ endsWith "Hello World" "World" &&
    _ endsWith "Hello World" " World" &&
    _ endsWith "Hello World" "Hello World" &&
    _ endsWith "/[a-zA-Z]/" "/" &&
    mustFail _ endsWith "Hello World" "Hello World " &&
    mustFail _ endsWith "Hello World" "world" &&
    mustFail _ endsWith "Hello World" ""
'

expectSuccess 'replace' '
    [[ "$(_ replace "Hello World" "World" "Bobby")" = "Hello Bobby" ]] &&
    [[ "$(_ replace "Hello World" " World" "Bobby")" = "HelloBobby" ]] &&
    [[ "$(_ replace "ho02123ware38384you443d34o3434ingtod38384day" "/[a-zA-Z]/" "X")" = "XX02123XXXX38384XXX443X34X3434XXXXXX38384XXX" ]] &&
    [[ "$(_ replace "ho02123ware38384you443d34o3434ingtod38384day" "/[0-9]/" "N")" = "hoNNNNNwareNNNNNyouNNNdNNoNNNNingtodNNNNNday" ]]
'

expectSuccess 'trimLines' '
  expected="$(cat "${FIXTURES}/trimLines/expected")"
  result="$(_ trimLines "$(cat "${FIXTURES}/trimLines/input")")"
  [ "$result" = "${expected}" ]
'

expectSuccess 'squeezeLines' '
  expected="$(cat "${FIXTURES}/squeezeLines/expected")"
  result="$(_ squeezeLines "$(cat "${FIXTURES}/squeezeLines/input")")"
  [ "$result" = "${expected}" ]
'

expectSuccess 'splitString' '
  result="$(echo "foo, bar, baz" | _ splitString)"
  string="$(echo -e "foo\nbar\nbaz")"
  [ "$result" =  "$string" ]
'

expectSuccess 'wrap' '
    expected="$(cat "${FIXTURES}/wrap/expected")"
    result="$(_ wrap "$(cat "${FIXTURES}/wrap/input")" 60)"

    [ "$result" = "${expected}" ]
'

finish
