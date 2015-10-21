#!/usr/bin/env bats

load helper

@test "Hello World" {
    run manage ello
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "World Hello!"            ]
    [ "${lines[1]}" = "Script name: ello"       ]
}

