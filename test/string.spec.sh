#!/usr/bin/env bash

source "${MANAGEDIRECTORY}/bin/manage"

MANAGE_UNDERSCORE string/camel
MANAGE_BOOTSTRAP

expectSuccess "Success is reported like this" '
    [[ "$(echo camel_Case | _ camel)" = "camelCase" ]]
'

expectSucess "Success is reported like this" "
    echo hello world | grep hello
"

expectSucess "Commands are chained this way" "
    test x = 'x' &&
    test 2 -gt 1 &&
    echo success
"

return_42() {
    echo "Will return soon"
    return 42
}

expectSucess "You can test for a specific exit code" "
    expectCode 42 return_42
"

expectFailure "We expect this to fail" "
    test 1 = 2
"

finish
