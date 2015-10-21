#!/usr/bin/env bats

load test-helper-external
manage="${BATS_PARENT_DIRNAME}/libexec/manage"

@test "Bootstrap: Bootstrap a script repository." {
    cd "${TMP}"
    run "${manage}" bootstrap
    [ "${status}" = "0"                         ]
}

@test "Bootstrap: Bootstrap a script repository and execute a script." {
    cd "${TMP}"
    "${manage}" bootstrap
    run "${TMP}/manage" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]
}

@test "Bootstrap: ... Execute a script and check the positional parameters." {
    cd "${TMP}"
    "${manage}" bootstrap
    mv "${TMP}"/manage "${TMP}"/alternate
    run "${TMP}/alternate" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: alternate"  ]
}


