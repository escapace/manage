#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090,SC2034

manage="${MANAGE_DIRECTORY}/manage"
FIXTURES="${SHARNESS_TEST_DIRECTORY}/fixtures/end-to-end"

expectSuccess "init" '
    "${manage}" init &&
    cp -f "${SHARNESS_TEST_DIRECTORY}/default.yml" "$(pwd)/.manage.yml" &&
    ./manage trust-escapace
'

expectSuccess "arguments" '
    readarray -t lines <<< "$("$(pwd)/manage" hello "Argument One" "Argument Two" "Argument Three" 2>/dev/null)"
    [ "${lines[5]}" = "Argument 1 : Argument One" ] &&
    [ "${lines[6]}" = "Argument 2 : Argument Two" ] &&
    [ "${lines[7]}" = "Argument 3 : Argument Three" ]
'

expectSuccess "inception" '
    cp -f "${FIXTURES}/inception" "$(pwd)/scripts/inception"
    cp -f "${FIXTURES}/inception_fail" "$(pwd)/scripts/inception_fail"

    readarray -t lines <<< "$("$(pwd)/manage" inception "Argument One" "Argument Two" "Argument Three" 2>/dev/null)"
    [ "${lines[5]}" = "Argument 1 : Argument One" ] &&
    [ "${lines[6]}" = "Argument 2 : Argument Two" ] &&
    [ "${lines[7]}" = "Argument 3 : Argument Three" ] &&
    expectCode 1 "$(pwd)/manage" inception_fail
'

expectSuccess "cwd change" '
    cwd="$(pwd)"
    cd /tmp
    whenFinished "cd ${cwd}"

    cp -f "${FIXTURES}/inception" "${cwd}/scripts/inception"
    cp -f "${FIXTURES}/inception_fail" "${cwd}/scripts/inception_fail"

    readarray -t lines <<< "$("${cwd}/manage" inception "Argument One" "Argument Two" "Argument Three" 2>/dev/null)"
    [ "${lines[3]}" = "Repository : ${cwd}" ] &&
    [ "${lines[4]}" = "PWD        : $(pwd)" ] &&
    [ "${lines[5]}" = "Argument 1 : Argument One" ] &&
    [ "${lines[6]}" = "Argument 2 : Argument Two" ] &&
    [ "${lines[7]}" = "Argument 3 : Argument Three" ] &&
    expectCode 1 "${cwd}/manage" inception_fail
'

expectSuccess "repository change" '
    cwd="$(pwd)"
    cd /tmp
    whenFinished "cd ${cwd}"

    cp -f "${FIXTURES}/inception" "${cwd}/scripts/inception"
    cp -f "${FIXTURES}/inception_fail" "${cwd}/scripts/inception_fail"

    readarray -t lines <<< "$("${manage}" "${cwd}" inception "Argument One" "Argument Two" "Argument Three" 2>/dev/null)"
    [ "${lines[3]}" = "Repository : ${cwd}" ] &&
    [ "${lines[4]}" = "PWD        : /tmp" ] &&
    [ "${lines[5]}" = "Argument 1 : Argument One" ] &&
    [ "${lines[6]}" = "Argument 2 : Argument Two" ] &&
    [ "${lines[7]}" = "Argument 3 : Argument Three" ] &&
    expectCode 1 "${manage}" "${cwd}" inception_fail
'

expectSuccess "full path script" '
    cwd="$(pwd)"
    cd /tmp
    whenFinished "cd ${cwd}"

    cp -f "${FIXTURES}/inception" "${cwd}/scripts/inception"
    cp -f "${FIXTURES}/inception_fail" "${cwd}/scripts/inception_fail"

    readarray -t lines <<< "$("${manage}" "${cwd}/scripts/inception" "Argument One" "Argument Two" "Argument Three" 2>/dev/null)"
    [ "${lines[3]}" = "Repository : ${cwd}" ] &&
    [ "${lines[4]}" = "PWD        : /tmp" ] &&
    [ "${lines[5]}" = "Argument 1 : Argument One" ] &&
    [ "${lines[6]}" = "Argument 2 : Argument Two" ] &&
    [ "${lines[7]}" = "Argument 3 : Argument Three" ] &&
    expectCode 1 "${manage}" "${cwd}/scripts/inception_fail"
'

# expectSuccess "completion" '
#     [ "$("$(pwd)/manage" _manage_completion hello)" = "$(cat "${FIXTURES}/completion")" ]
# '

expectSuccess "stdin" '
    cp -f "${FIXTURES}/pipe" "$(pwd)/scripts/pipe"
    readarray -t lines <<< "$(echo "A pipe" | "$(pwd)/manage" pipe)"
    [ "${lines[0]}" = "A pipe" ]
'

expectSuccess "caller name" '
    mv "$(pwd)/manage" "$(pwd)/alternate"
    readarray -t lines <<< "$("$(pwd)/alternate" hello 2>/dev/null)"
    [ "${lines[2]}" = "Caller name: alternate" ] &&
    whenFinished "mv $(pwd)/alternate $(pwd)/manage"
'

expectSuccess "exitCodes" '
    cp -rf "${FIXTURES}/onExit" "$(pwd)/scripts"
    expectCode 45 "$(pwd)/manage" s-return-onexit &&
    expectCode 45 "$(pwd)/manage" s-exit-onexit &&
    expectCode 1 "$(pwd)/manage" s-err-onexit &&
    expectCode 0 "$(pwd)/manage" s-hello-onexit &&
    expectCode 0 "$(pwd)/manage" ns-hello-onexit &&
    expectCode 1 "$(pwd)/manage" ns-err-onexit &&
    expectCode 45 "$(pwd)/manage" ns-return-onexit &&
    expectCode 45 "$(pwd)/manage" ns-exit-onexit
'

expectSuccess "enable" '
    cp -f "${FIXTURES}/enable.yml" "$(pwd)/.manage.yml"
    mustFail "$(pwd)/manage" test
'

expectSuccess "default script" '
    cp -f "${FIXTURES}/default-hello.yml" "$(pwd)/.manage.yml"
    readarray -t lines <<< "$("$(pwd)/manage" 2>/dev/null)"
    [ "${lines[0]}" = "Hello World!"            ] &&
    [ "${lines[1]}" = "Script name: hello"      ]
'

expectSuccess "environment" '
    cp -f "${FIXTURES}/env.yml" "$(pwd)/.manage.yml"
    readarray -t lines <<< "$("$(pwd)/manage" hello 2>/dev/null)"
    [ "${lines[0]}" = "Modified environment"    ] &&
    [ "${lines[1]}" = "Script name: hello"      ]
'

expectSuccess "environment override" '
    cp -f "${FIXTURES}/env.yml" "$(pwd)/.manage.yml"
    readarray -t lines <<< "$(HELLO=QWE "$(pwd)/manage" hello 2>/dev/null)"
    [ "${lines[0]}" = "QWE" ] &&
    [ "${lines[1]}" = "Script name: hello" ]
'

expectSuccess "directories" '
    cp -f "${FIXTURES}/directories.yml" "$(pwd)/.manage.yml"
    mv "$(pwd)/scripts/modules" "$(pwd)/modules" &&
    mv "$(pwd)/scripts" "$(pwd)/other" &&
    mv "$(pwd)/other" "$(pwd)/scripts" &&
    mv "$(pwd)/modules" "$(pwd)/scripts/modules" &&
    cp -f "${FIXTURES}/default.yml" "$(pwd)/.manage.yml"
'

expectSuccess "import" '
    cp -f "${FIXTURES}/import-https" "$(pwd)/scripts/import-https" &&
    expectCode 0 "$(pwd)/manage" import-https
'

expectSuccess "import github.com" '
    cp -f "${FIXTURES}/import-no-https" "$(pwd)/scripts/import-no-https" &&
    expectCode 0 "$(pwd)/manage" import-no-https
'

finish

