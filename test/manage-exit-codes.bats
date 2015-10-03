load test-helper-external
fixtures manage-exit-codes
manage="${FIXTURE_ROOT}/manage"

@test "Manage Exit Codes: Check script exit code with strict mode enabled, script return 45." {
    run "${manage}" s-return-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

@test "Manage Exit Codes: Check script exit code with strict mode enabled, script exits with code 45." {
    run "${manage}" s-exit-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

@test "Manage Exit Codes: Check script exit code with strict mode enabled, script has an error." {
    run "${manage}" s-err-onexit
    [ "${output}" = "onexit 1"     ]
    [ "${status}" = "1"            ]
}

@test "Manage Exit Codes: Check script exit code with strict mode enabled, script exits with code 0." {
    run "${manage}" s-hello-onexit
    [ "${output}" = "onexit 0"     ]
    [ "${status}" = "0"            ]
}

@test "Manage Exit Codes: Check script exit code with strict mode disabled, script exits with code 0." {
    run "${manage}" ns-hello-onexit
    [ "${output}" = "onexit 0"     ]
    [ "${status}" = "0"            ]
}

@test "Manage Exit Codes: Check script exit code with strict mode disabled, script has an error." {
    run "${manage}" ns-err-onexit
    [ "${output}" = "onexit 1"     ]
    [ "${status}" = "1"            ]
}

@test "Manage Exit Codes: Check script exit code with strict mode disabled, script returns 45." {
    run "${manage}" ns-return-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

@test "Manage Exit Codes: Check script exit code with strict mode disabled, script exits with code 45." {
    run "${manage}" ns-exit-onexit
    [ "${output}" = "onexit 45"    ]
    [ "${status}" = "45"           ]
}

