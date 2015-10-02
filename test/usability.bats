#!/usr/bin/env bats

load test_helper
fixtures usability
manage="${FIXTURE_ROOT}/eganam"
MANAGE="${BMANAGELIBEXEC}/manage"

@test "Usability: Execute a repostory script." {
    run "${manage}" success
    [ "${output}" = "Hello World!!!" ]
    [ "${status}" = "0"              ]
}

@test "Usability: Execute a repostory script from another script." {
    cd "${TMP}"
    run "${manage}" something
    [ "${output}" = "Hello World!!!" ]
    [ "${status}" = "0"              ]
}

@test "Usability: Proper argument handling." {
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

@test "Usability: Execute external repository script with linked manage from FIXTURE_ROOT." {
    cd "${TMP}"
    "${MANAGE}" bootstrap
    run "${TMP}/manage" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]

    cd "${FIXTURE_ROOT}"
    run "${manage}" "${TMP}" hello yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: hello"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
}

@test "Usability: Execute external repository script with libexec manage from FIXTURE_ROOT." {
    cd "${TMP}"
    "${MANAGE}" bootstrap
    run "${TMP}/manage" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]

    cd "${FIXTURE_ROOT}"
    run "${MANAGE}" "${TMP}" hello yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: hello"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
}

@test "Usability: Execute external script with linked manage from FIXTURE_ROOT." {
    cd "${TMP}"
    "${MANAGE}" bootstrap
    run "${TMP}/manage" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]

    cd "${FIXTURE_ROOT}"
    run "${manage}" "${TMP}/script/hello" yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: hello"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
}

@test "Usability: Execute external script with libexec manage from FIXTURE_ROOT." {
    cd "${TMP}"
    "${MANAGE}" bootstrap
    run "${TMP}/manage" hello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
    [ "${lines[2]}" = "Caller name: manage"     ]

    cd "${FIXTURE_ROOT}"
    run "${MANAGE}" "${TMP}/script/hello" yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: hello"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
}

@test "Usability: Execute repository script with linked manage from FIXTURE_ROOT." {
    cd "${FIXTURE_ROOT}"
    run "${manage}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
}

@test "Usability: Execute repository script with linked manage from TMP." {
    cd "${TMP}"
    run "${manage}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
}

@test "Usability: Execute repository script with linked manage from TMP, script path as an argument." {
    cd "${TMP}"
    run "${manage}" "${FIXTURE_ROOT}/script/aloha" yeah
    echo "${output}"
    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: eganam"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
}

@test "Usability: Execute script with libexec manage from FIXTURE_ROOT." {
    cd "${FIXTURE_ROOT}"
    run "${MANAGE}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${FIXTURE_ROOT}"    ]
}

@test "Usability: Execute repository script with libexec manage from TMP, repository path as an argument." {
    cd "${TMP}"
    run "${MANAGE}" "${FIXTURE_ROOT}" aloha yeah

    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
}

@test "Usability: Execute script with libexec manage from TMP, script path as an argument." {
    cd "${TMP}"
    run "${MANAGE}" "${FIXTURE_ROOT}/script/aloha" yeah
    echo "${output}"
    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
}

@test "Usability: Execute repository script from TMP with libexec manage in PATH." {
    PATH="$BMANAGELIBEXEC:$PATH"
    cd "${TMP}"
    run "${FIXTURE_ROOT}/script/aloha" yeah
    [ "${status}"   = "0"                               ]
    [ "${lines[0]}" = "Hello World!"                    ]
    [ "${lines[1]}" = "Script name: aloha"              ]
    [ "${lines[2]}" = "Caller name: manage"             ]
    [ "${lines[3]}" = "Arguments  : yeah"               ]
    [ "${lines[4]}" = "PWD        : ${TMP}"             ]
}

@test "Usability: Check script exit code with strict mode enabled, script return 45." {
    run "${manage}" s-return-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

@test "Usability: Check script exit code with strict mode enabled, script exits with code 45." {
    run "${manage}" s-exit-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

@test "Usability: Check script exit code with strict mode enabled, script has an error." {
    run "${manage}" s-err-onexit
    [ "${output}" = "onexit 1"     ]
    [ "${status}" = "1"            ]
}

@test "Usability: Check script exit code with strict mode enabled, script exits with code 0." {
    run "${manage}" s-hello-onexit
    [ "${output}" = "onexit 0"     ]
    [ "${status}" = "0"            ]
}

@test "Usability: Check script exit code with strict mode disabled, script exits with code 0." {
    run "${manage}" ns-hello-onexit
    [ "${output}" = "onexit 0"     ]
    [ "${status}" = "0"            ]
}

@test "Usability: Check script exit code with strict mode disabled, script has an error." {
    run "${manage}" ns-err-onexit
    [ "${output}" = "onexit 1"     ]
    [ "${status}" = "1"            ]
}

@test "Usability: Check script exit code with strict mode disabled, script returns 45." {
    run "${manage}" ns-return-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

@test "Usability: Check script exit code with strict mode disabled, script exits with code 45." {
    run "${manage}" ns-exit-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

@test "Usability: Execute script and check stdin." {
    IFS=$'\n\t'
    lines=($(echo "A pipe" | "${manage}" pipe))
    [ "${lines[0]}" = "A pipe"     ]
    [ "${lines[1]}" = "onexit 0"   ]
}
