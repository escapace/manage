#!/usr/bin/env bats

load test-helper-external
fixtures manage-completion

manage="${FIXTURE_ROOT}/manage"

@test "Manage completion" {
    run "${manage}" completion test

    [ "${output}" = "hello" ]
    [ "${status}"   = "0"   ]
}
