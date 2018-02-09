#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090,SC2034,SC1117

source "${MANAGE_DIRECTORY}/manage"
FIXTURES="${SHARNESS_TEST_DIRECTORY}/fixtures"

MANAGE_UNDERSCORE \
    console/hr \
    console/br \
    console/tab \
    console/log \
    console/info \
    console/debug \
    console/error \
    console/warn \
    console/icon \
    console/emoji \
    console/bgcolor \
    console/fgcolor \
    console/progress \
    console/attribute

MANAGE_BOOTSTRAP

# TODO: progress
# TODO: die

ipsum="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur."

assert_equal () {
    local description="$3"
    local expectation="$2"
    local source="$1"

    expectSuccess "${description}" "[[ \"${source}\" = \"${expectation}\" ]]"
}

expectSuccess 'log' '
    verbose true &&
    [[ "$(_ log "${ipsum}" "${ipsum}")" = "$(cat "${FIXTURES}/log/expected")" ]]
'

expectSuccess 'debug' '
    verbose true &&
    [[ "$(_ debug "${ipsum}" "${ipsum}")" = "$(cat "${FIXTURES}/debug/expected")" ]] &&
    [[ "$(_ log debug "${ipsum}" "${ipsum}")" = "$(cat "${FIXTURES}/debug/expected")" ]]
'

expectSuccess 'info' '
    verbose true &&
    [[ "$(_ info "${ipsum}" "${ipsum}")" = "$(cat "${FIXTURES}/info/expected")" ]] &&
    [[ "$(_ log info "${ipsum}" "${ipsum}")" = "$(cat "${FIXTURES}/info/expected")" ]]
'

expectSuccess 'warn' '
    verbose true &&
    [[ "$( { _ warn "${ipsum}" "${ipsum}"; } 2>&1 )" = "$(cat "${FIXTURES}/warn/expected")" ]] &&
    [[ "$( { _ log warn "${ipsum}" "${ipsum}"; } 2>&1 )" = "$(cat "${FIXTURES}/warn/expected")" ]]
'

expectSuccess 'error' '
    verbose true &&
    [[ "$( { _ error "${ipsum}" "${ipsum}"; } 2>&1 )" = "$(cat "${FIXTURES}/error/expected")" ]] &&
    [[ "$( { _ log error "${ipsum}" "${ipsum}"; } 2>&1 )" = "$(cat "${FIXTURES}/error/expected")" ]]
'

expectSuccess 'tab' '
    [[ "$(_ tab)" = "$(echo -e "\t")" ]]
'

expectSuccess 'br' '
    [[ "$(_ br)" = "$(echo -ne "\n\r")" ]]
'

expectSuccess 'hr' '
    [[ "$(_ hr)" = "------------------------------------------------------------" ]] &&
    [[ "$(_ hr 4)" = "----" ]] &&
    [[ "$(_ hr "." 4)" = "...." ]]
'

assert_equal "$(_ emoji smiley)" '😃' \
    "emoji smiley"

assert_equal "$(_ emoji halo)" '😇' \
    "emoji halo"

assert_equal "$(_ emoji lol)" '😂' \
    "emoji lol"

assert_equal "$(_ emoji tongue)" '😛' \
    "emoji tongue"

assert_equal "$(_ emoji blush)" '😊' \
    "emoji blush"

assert_equal "$(_ emoji sad)" '😟' \
    "emoji sad"

assert_equal "$(_ emoji cry)" '😢' \
    "emoji cry"

assert_equal "$(_ emoji rage)" '😡' \
    "emoji rage"

assert_equal "$(_ emoji wave)" '👋' \
    "emoji wave"

assert_equal "$(_ emoji ok)" '👌' \
    "emoji ok"

assert_equal "$(_ emoji +1)" '👍' \
    "emoji +1"

assert_equal "$(_ emoji thumbsdown)" '👎' \
    "emoji thumbsdown"

assert_equal "$(_ emoji happycat)" '😺' \
    "emoji happycat"

assert_equal "$(_ emoji cat)" '🐱' \
    "emoji cat"

assert_equal "$(_ emoji dog)" '🐶' \
    "emoji dog"

assert_equal "$(_ emoji bee)" '🐝' \
    "emoji bee"

assert_equal "$(_ emoji pig)" '🐷' \
    "emoji pig"

assert_equal "$(_ emoji monkey)" '🐵' \
    "emoji monkey"

assert_equal "$(_ emoji cow)" '🐮' \
    "emoji cow"

assert_equal "$(_ emoji panda)" '🐼' \
    "emoji panda"

assert_equal "$(_ emoji raw)" '🍣' \
    "emoji raw"

assert_equal "$(_ emoji house)" '🏠' \
    "emoji house"

assert_equal "$(_ emoji eyeglasses)" '👓' \
    "emoji eyeglasses"

assert_equal "$(_ emoji smoke)" '🚬' \
    "emoji smoke"

assert_equal "$(_ emoji fire)" '🔥' \
    "emoji fire"

assert_equal "$(_ emoji poop)" '💩' \
    "emoji poop"

assert_equal "$(_ emoji beer)" '🍺' \
    "emoji beer"

assert_equal "$(_ emoji cookie)" '🍪' \
    "emoji cookie"

assert_equal "$(_ emoji lock)" '🔒' \
    "emoji lock"

assert_equal "$(_ emoji unlock)" '🔓' \
    "emoji unlock"

assert_equal "$(_ emoji star)" '⭐' \
    "emoji star"

assert_equal "$(_ emoji joker)" '🃏' \
    "emoji joker"

assert_equal "$(_ emoji check)" '✅' \
    "emoji check"

assert_equal "$(_ emoji xmark)" '❌' \
    "emoji xmark"

assert_equal "$(_ emoji loo)" '🚽' \
    "emoji loo"

assert_equal "$(_ emoji bell)" '🔔' \
    "emoji bell"

assert_equal "$(_ emoji search)" '🔎' \
    "emoji search"

assert_equal "$(_ emoji dart)" '🎯' \
    "emoji dart"

assert_equal "$(_ emoji cream)" '💵' \
    "emoji cream"

assert_equal "$(_ emoji thinking)" '💭' \
    "emoji thinking"

assert_equal "$(_ emoji luck)" '🍀' \
    "emoji luck"

assert_equal "$(_ emoji somethingIdontKnowAbout)" '' \
    "fail gracefully"

assert_equal "$(_ icon check)" "✓" \
    "icon check"

assert_equal "$(_ icon xmark)" "✘" \
    "icon xmark"

assert_equal "$(_ icon heart)" "❤" \
    "icon heart"

assert_equal "$(_ icon sun)" "☀" \
    "icon sun"

assert_equal "$(_ icon star)" "★" \
    "icon star"

assert_equal "$(_ icon darkstar)" "☆" \
    "icon darkstar"

assert_equal "$(_ icon umbrella)" "☂" \
    "icon umbrella"

assert_equal "$(_ icon flag)" "⚑" \
    "icon flag"

assert_equal "$(_ icon snow)" "❄" \
    "icon snow"

assert_equal "$(_ icon music)" "♫" \
    "icon music"

assert_equal "$(_ icon scissors)" "✂" \
    "icon scissors"

assert_equal "$(_ icon tm)" "™" \
    "icon tm"

assert_equal "$(_ icon copyright)" "©" \
    "icon copyright"

assert_equal "$(_ icon apple)" "" \
    "icon apple"

assert_equal "$(_ icon skull)" "☠" \
    "icon skull"

assert_equal "$(_ icon face)" "☺" \
    "icon face"

assert_equal "$(_ icon "somethingThatWillNeverExist")" "" \
    "fails gracefully"

assert_equal "$(_ attribute bold)foo$(_ attribute end)" \
    "$(echo -e '\033[1mfoo\033[0m')" \
    'bold text and end'

assert_equal "$(_ attribute dim)foo$(_ attribute)" \
    "$(echo -e '\033[2mfoo\033[0m')" \
    'dim text and end'

assert_equal "$(_ attribute underline)foo$(_ attribute)" \
    "$(echo -e '\033[4mfoo\033[0m')" \
    'underlined text and end'

assert_equal "$(_ attribute blink)foo$(_ attribute)" \
    "$(echo -e '\033[5mfoo\033[0m')" \
    'blinking text and end'

assert_equal "$(_ attribute invert)foo$(_ attribute)" \
    "$(echo -e '\033[7mfoo\033[0m')" \
    'inverted text and end'

assert_equal "$(_ attribute hidden)foo$(_ attribute)" \
    "$(echo -e '\033[8mfoo\033[0m')" \
    'hidden text and end'

assert_equal "$(_ attribute bold)foo$(_ attribute end)" \
    "$(echo -e '\033[1mfoo\033[0m')" \
    'modified text and end'

assert_equal "$(_ attribute bold)foo$(_ attribute off)" \
    "$(echo -e '\033[1mfoo\033[0m')" \
    'modified text and end'

assert_equal "$(_ attribute bold)foo$(_ attribute reset)" \
    "$(echo -e '\033[1mfoo\033[0m')" \
    'modified text and end'

assert_equal "$(_ bgcolor black 'foo')" \
    "$(echo -e '\033[40mfoo\033[49m')" \
    "black background color"

assert_equal "$(_ bgcolor red 'foo')" \
    "$(echo -e '\033[41mfoo\033[49m')" \
    "red background color"

assert_equal "$(_ bgcolor green 'foo')" \
    "$(echo -e '\033[42mfoo\033[49m')" \
    "green background color"

assert_equal "$(_ bgcolor yellow 'foo')" \
    "$(echo -e '\033[43mfoo\033[49m')" \
    "yellow background color"

assert_equal "$(_ bgcolor blue 'foo')" \
    "$(echo -e '\033[44mfoo\033[49m')" \
    "blue background color"

assert_equal "$(_ bgcolor magenta 'foo')" \
    "$(echo -e '\033[45mfoo\033[49m')" \
    "magenta background color"

assert_equal "$(_ bgcolor cyan 'foo')" \
    "$(echo -e '\033[46mfoo\033[49m')" \
    "cyan background color"

assert_equal "$(_ bgcolor gray 'foo')" \
    "$(echo -e '\033[47mfoo\033[49m')" \
    "gray background color"

assert_equal "$(_ bgcolor gray 'foo')" \
    "$(echo -e '\033[47mfoo\033[49m')" \
    "gray background color"

assert_equal "$(_ bgcolor darkgray 'foo')" \
    "$(echo -e '\033[100mfoo\033[49m')" \
    "darkgray background color"

assert_equal "$(_ bgcolor lightred 'foo')" \
    "$(echo -e '\033[101mfoo\033[49m')" \
    "lightred background color"

assert_equal "$(_ bgcolor lightgreen 'foo')" \
    "$(echo -e '\033[102mfoo\033[49m')" \
    "lightgreen background color"

assert_equal "$(_ bgcolor lightyellow 'foo')" \
    "$(echo -e '\033[103mfoo\033[49m')" \
    "lightyellow background color"

assert_equal "$(_ bgcolor lightblue 'foo')" \
    "$(echo -e '\033[104mfoo\033[49m')" \
    "lightblue background color"

assert_equal "$(_ bgcolor lightmagenta 'foo')" \
    "$(echo -e '\033[105mfoo\033[49m')" \
    "lightmagenta background color"

assert_equal "$(_ bgcolor lightcyan 'foo')" \
    "$(echo -e '\033[106mfoo\033[49m')" \
    "lightcyan background color"

assert_equal "$(_ bgcolor white 'foo')" \
    "$(echo -e '\033[107mfoo\033[49m')" \
    "white background color"

# Terminators
assert_equal "$(_ bgcolor white)foo$(_ bgcolor)" \
    "$(echo -e '\033[107mfoo\033[49m')" \
    'color background and end color'

assert_equal "$(_ bgcolor red)foo$(_ bgcolor end)" \
    "$(echo -e '\033[41mfoo\033[49m')" \
    'color background and end color'

assert_equal "$(_ bgcolor red)foo$(_ bgcolor off)" \
    "$(echo -e '\033[41mfoo\033[49m')" \
    'color background and end color'

assert_equal "$(_ bgcolor red)foo$(_ bgcolor reset)" \
    "$(echo -e '\033[41mfoo\033[49m')" \
    'color background and end color'

assert_equal "$(_ fgcolor black 'foo')" \
    "$(echo -e '\033[30mfoo\033[39m')" \
    "black foreground color"

assert_equal "$(_ fgcolor red 'foo')" \
    "$(echo -e '\033[31mfoo\033[39m')" \
    "red foreground color"

assert_equal "$(_ fgcolor green 'foo')" \
    "$(echo -e '\033[32mfoo\033[39m')" \
    "green foreground color"

assert_equal "$(_ fgcolor yellow 'foo')" \
    "$(echo -e '\033[33mfoo\033[39m')" \
    "yellow foreground color"

assert_equal "$(_ fgcolor blue 'foo')" \
    "$(echo -e '\033[34mfoo\033[39m')" \
    "blue foreground color"

assert_equal "$(_ fgcolor magenta 'foo')" \
    "$(echo -e '\033[35mfoo\033[39m')" \
    "magenta foreground color"

assert_equal "$(_ fgcolor cyan 'foo')" \
    "$(echo -e '\033[36mfoo\033[39m')" \
    "cyan foreground color"

assert_equal "$(_ fgcolor gray 'foo')" \
    "$(echo -e '\033[90mfoo\033[39m')" \
    "gray foreground color"

assert_equal "$(_ fgcolor darkgray 'foo')" \
    "$(echo -e '\033[91mfoo\033[39m')" \
    "darkgray foreground color"

assert_equal "$(_ fgcolor lightgreen 'foo')" \
    "$(echo -e '\033[92mfoo\033[39m')" \
    "lightgreen foreground color"

assert_equal "$(_ fgcolor lightyellow 'foo')" \
    "$(echo -e '\033[93mfoo\033[39m')" \
    "lightyellow foreground color"

assert_equal "$(_ fgcolor lightblue 'foo')" \
    "$(echo -e '\033[94mfoo\033[39m')" \
    "lightblue foreground color"

assert_equal "$(_ fgcolor lightmagenta 'foo')" \
    "$(echo -e '\033[95mfoo\033[39m')" \
    "lightmagenta foreground color"

assert_equal "$(_ fgcolor lightcyan 'foo')" \
    "$(echo -e '\033[96mfoo\033[39m')" \
    "lightcyan foreground color"

assert_equal "$(_ fgcolor white 'foo')" \
    "$(echo -e '\033[97mfoo\033[39m')" \
    "white foreground color"

# Terminators
assert_equal "$(_ fgcolor white)foo$(_ fgcolor)" \
    "$(echo -e '\033[97mfoo\033[39m')" \
    'color foreground and end color'

assert_equal "$(_ fgcolor white)foo$(_ fgcolor end)" \
    "$(echo -e '\033[97mfoo\033[39m')" \
    'color foreground and end color'

assert_equal "$(_ fgcolor white)foo$(_ fgcolor off)" \
    "$(echo -e '\033[97mfoo\033[39m')" \
    'color foreground and end color'

assert_equal "$(_ fgcolor white)foo$(_ fgcolor reset)" \
    "$(echo -e '\033[97mfoo\033[39m')" \
    'color foreground and end color'

# Mixed
##
assert_equal "$(_ bgcolor white)$(_ fgcolor black foo)$(_ bgcolor)" \
    "$(echo -e '\033[107m\033[30mfoo\033[39m\033[49m')" \
    'works with nested stuffs'

assert_equal "$(_ bgcolor "white")$(_ fgcolor 'black' "foo")$(_ bgcolor "end")" \
    "$(echo -e '\033[107m\033[30mfoo\033[39m\033[49m')" \
    'works with mixed quoting'

example_string="foo bar\nbah\tbin"

assert_equal "$(_ bgcolor white)$(_ fgcolor black "$example_string")$(_ bgcolor)" \
    "$(echo -e "\033[107m\033[30mfoo bar\nbah\tbin\033[39m\033[49m")" \
    "works with variables"

finish
