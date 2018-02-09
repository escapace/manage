#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090,SC2034

manage="${MANAGE_DIRECTORY}/manage"
FIXTURES="${SHARNESS_TEST_DIRECTORY}/fixtures/failure-modes"

expectSuccess "init" '
    gpg --keyserver ha.pool.sks-keyservers.net --recv-key 13F26F82E955B8B8CE469054F29CCEBC83FD4525 &&
    "${manage}" init &&
    "$(pwd)/manage" test
'
expectSuccess "function is not defined" '
    cp -f "${FIXTURES}/notDefined" "$(pwd)/scripts/notDefined" &&
    message="$("$(pwd)/manage" notDefined 2>&1 || true)" &&
    [[ "${message}" =~ "is not defined" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "not a repository" '
    cp -f "${FIXTURES}/notRepository" "$(pwd)/scripts/notRepository" &&
    message="$("$(pwd)/manage" notRepository 2>&1 || true)" &&
    [[ "${message}" =~ "valid manage repository" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "version conflict" '
    cp -f "${FIXTURES}/diffVersion" "$(pwd)/scripts/diffVersion" &&
    message="$("$(pwd)/manage" diffVersion 2>&1 || true)" &&
    [[ "${message}" =~ "different versions" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "invalid query" '
    cp -f "${FIXTURES}/invalidQuery" "$(pwd)/scripts/invalidQuery" &&
    message="$("$(pwd)/manage" invalidQuery 2>&1 || true)" &&
    [[ "${message}" =~ "invalid option" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "invalid version" '
    cp -f "${FIXTURES}/invalidVersion" "$(pwd)/scripts/invalidVersion" &&
    message="$("$(pwd)/manage" invalidVersion 2>&1 || true)" &&
    [[ "${message}" =~ "version option" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "import failure" '
    cp -f "${FIXTURES}/failImport" "$(pwd)/scripts/failImport" &&
    message="$("$(pwd)/manage" failImport 2>&1 || true)" &&
    [[ "${message}" =~ "failed to import" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "fail to verify" '
    cp -f "${FIXTURES}/failVerify" "$(pwd)/scripts/failVerify" &&
    message="$("$(pwd)/manage" failVerify 2>&1 || true)" &&
    [[ "${message}" =~ "failed to verify" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "collision" '
    mkdir "$(pwd)/scripts/modules/another-example" &&
    cp -f "${FIXTURES}/another-example/hello" "$(pwd)/scripts/modules/another-example/hello" &&
    cp -f "${FIXTURES}/collision" "$(pwd)/scripts/collision" &&
    message="$("$(pwd)/manage" collision 2>&1 || true)" &&
    [[ "${message}" =~ "two different functions" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "edge-case-a" '
    cp -f "${FIXTURES}/edge-case-a" "$(pwd)/scripts/edge-case-a" &&
    message="$("$(pwd)/manage" edge-case-a 2>&1 || true)" &&
    [[ "${message}" =~ "failed to import" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "edge-case-b" '
    cp -f "${FIXTURES}/edge-case-b" "$(pwd)/scripts/edge-case-b" &&
    message="$("$(pwd)/manage" edge-case-b 2>&1 || true)" &&
    [[ "${message}" =~ "failed to import" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "import failure local" '
    cp -f "${FIXTURES}/failImportLocal" "$(pwd)/scripts/failImportLocal" &&
    message="$("$(pwd)/manage" failImportLocal 2>&1 || true)" &&
    [[ "${message}" =~ "failed to import" ]] &&
    [[ "${message}" =~ ERROR ]]
'

expectSuccess "import twice" '
    cp -f "${FIXTURES}/importTwice" "$(pwd)/scripts/importTwice" &&
    message="$("$(pwd)/manage" importTwice 2>&1 || true)" &&
    [[ "${message}" =~ "failed to import" ]] &&
    [[ "${message}" =~ ERROR ]]
'

finish
