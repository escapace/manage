#!/usr/bin/env bats

load test-helper-external
fixtures manage-arguments
manage="${FIXTURE_ROOT}/eganam"
MANAGE="${BATSMANAGELIBEXEC}/manage"

@test "Manage Arguments: Simply execute a repostory script." {
    run "${manage}" success
    [ "${output}" = "Hello World!!!" ]
    [ "${status}" = "0"              ]
}

@test "Manage Arguments: Execute a script from another script." {
    cd "${TMP}"
    run "${manage}" something
    [ "${output}" = "Hello World!!!" ]
    [ "${status}" = "0"              ]
}

@test "Manage Arguments: Proper argument handling." {
    cd "${TMP}"
    "${MANAGE}" bootstrap
    run "${TMP}/manage" hello qwe "zxc ad"
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]
    [ "${lines[3]}" = "Arguments  : qwe zxc ad" ]
    [ "${lines[4]}" = "PWD        : ${TMP}"     ]
    [ "${lines[5]}" = "Argument 1 : qwe"        ]
    [ "${lines[6]}" = "Argument 2 : zxc ad"     ]
}

@test "Manage Arguments: Execute external repository script with linked manage from FIXTURE_ROOT." {
    cd "${TMP}"
    "${MANAGE}" bootstrap
    run "${TMP}/manage" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]
    [ "${lines[8]}" = "Repository : ${TMP}"     ]

    cd "${FIXTURE_ROOT}"
    run "${manage}" "${TMP}" hello yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: hello"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
    [ "${lines[8]}" = "Repository : ${TMP}"             ]
}

@test "Manage Arguments: Execute external repository script with libexec manage from FIXTURE_ROOT." {
    cd "${TMP}"
    "${MANAGE}" bootstrap
    run "${TMP}/manage" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]
    [ "${lines[8]}" = "Repository : ${TMP}"     ]

    cd "${FIXTURE_ROOT}"
    run "${MANAGE}" "${TMP}" hello yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: hello"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
    [ "${lines[8]}" = "Repository : ${TMP}"             ]
}

@test "Manage Arguments: Execute repository script with linked manage from FIXTURE_ROOT." {
    cd "${FIXTURE_ROOT}"
    run "${manage}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
    [ "${lines[8]}" = "Repository : ${FIXTURE_ROOT}"    ]
}

@test "Manage Arguments: Execute repository script with linked manage from TMP." {
    cd "${TMP}"
    run "${manage}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
    [ "${lines[8]}" = "Repository : ${FIXTURE_ROOT}"    ]
}

@test "Manage Arguments: Execute repository script with linked manage from TMP, script path as an argument." {
    cd "${TMP}"
    run "${manage}" "${FIXTURE_ROOT}/script/aloha" yeah
    echo "${output}"
    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
    [ "${lines[8]}" = "Repository : ${FIXTURE_ROOT}"    ]
}

@test "Manage Arguments: Execute script with libexec manage from FIXTURE_ROOT." {
    cd "${FIXTURE_ROOT}"
    run "${MANAGE}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
    [ "${lines[8]}" = "Repository : ${FIXTURE_ROOT}"    ]
}

@test "Manage Arguments: Execute repository script with libexec manage from TMP, repository path as an argument." {
    cd "${TMP}"
    run "${MANAGE}" "${FIXTURE_ROOT}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
    [ "${lines[8]}" = "Repository : ${FIXTURE_ROOT}"    ]
}

@test "Manage Arguments: Execute script with libexec manage from TMP, script path as an argument." {
    cd "${TMP}"
    run "${MANAGE}" "${FIXTURE_ROOT}/script/aloha" yeah
    echo "${output}"
    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
    [ "${lines[8]}" = "Repository : ${FIXTURE_ROOT}"    ]
}

@test "Manage Arguments: Execute repository script from TMP with libexec manage in PATH." {
    PATH="$BATSMANAGELIBEXEC:$PATH"
    cd "${TMP}"
    run "${FIXTURE_ROOT}/script/aloha" yeah
    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
    [ "${lines[8]}" = "Repository : ${FIXTURE_ROOT}"    ]
}

@test "Manage Arguments: Execute script and check stdin." {
    IFS=$'\n\t'
    lines=($(echo "A pipe" | "${manage}" pipe))
    [ "${lines[0]}" = "A pipe"     ]
    [ "${lines[1]}" = "onexit 0"   ]
}

@test "Manage Arguments: Execute external script from TMP with libexec manage in PATH." {
    PATH="$BATSMANAGELIBEXEC:$PATH"
    cd "${TMP}"
    cp "${FIXTURE_ROOT}/script/aloha" "${TMP}/aloha"

    HELLO="Hello World!!!"
    export HELLO

    run "${TMP}/aloha" yeah

    [ "${status}"   = "0"                                   ]
    [ "${lines[0]}" = "Hello World!!!"                      ]
    [ "${lines[1]}" = "Script name: aloha"                  ]
    [ "${lines[2]}" = "Caller name: manage"                 ]
    [ "${lines[3]}" = "Arguments  : yeah"                   ]
    [ "${lines[4]}" = "PWD        : ${TMP}"                 ]
    [ "${lines[8]}" = "Repository : ${BATSMANAGEDIRECTORY}" ]
}

