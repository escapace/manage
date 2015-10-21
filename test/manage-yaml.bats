#!/usr/bin/env bats

load test-helper-external
fixtures manage-yaml

manage="${FIXTURE_ROOT}/stde/manage"

@test "Manage manage.yml: alternate script directory." {
    run "${manage}" ello
    echo "${output}"
    [ "${lines[0]}" = "World Hello!" ]
    [ "${status}"   = "0"            ]
}

@test "Manage manage.yml: alternate default script." {
    run "${manage}"
    echo "${output}"
    [ "${lines[0]}" = "World Hello!" ]
    [ "${status}"   = "0"            ]
}

@test "Manage manage.yml: environment variables." {
    run "${manage}" env
    [ "${lines[0]}" = "qwe" ]
    [ "${lines[1]}" = "asd" ]
    [ "${lines[2]}" = "zxc" ]
    [ "${status}"   = "0"   ]
}

@test "Manage manage.yml: dependecies." {
    manage="${FIXTURE_ROOT}/dep/manage"

    run "${manage}"
    [ "${status}"   = "1"   ]
}
