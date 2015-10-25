#!/usr/bin/env bats

load helper

@test "Hello World" {
    run manage hello qwe "zxc ad"
    [ "${status}"   = "0"                       ]
    [ "${lines[0]}" = "Hello World!"            ]
    [ "${lines[1]}" = "Script name: hello"      ]
}

