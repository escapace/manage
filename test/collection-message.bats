#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-message"

@test "Collection-message: echo" {
    verbose || [[ $? == 1 ]]
    [ "$(_ echo istrue isfalse)" = "isfalse" ]
    verbose false
    [ "$(_ echo istrue isfalse)" = "isfalse" ]
    verbose true
    verbose
    [ "$(_ echo istrue isfalse)" = "istrue" ]
    verbose false
    [ "$(_ echo istrue isfalse)" = "isfalse" ]
}

@test "Collection-message: die" {
    regex="^.*(A message \!)$"

    verbose false
    [ -z "$(_ die "A message !")" ]

    _ die "A message !" || [[ $? == 1 ]]

    verbose true
    [[ "$((_ die "A message !") 2>&1)" =~ ${regex} ]]
}

@test "Collection-message: info" {
    regex="^.*(A message \!)$"

    verbose false
    [ -z "$(_ info "A message !")" ]

    verbose true
    [[ "$((_ info "A message !") 2>&1)" =~ ${regex} ]]
}

@test "Collection-message: warn" {
    regex="^.*(A message \!)$"

    verbose false
    [ -z "$(_ warn "A message !")" ]

    verbose true
    [[ "$((_ warn "A message !") 2>&1)" =~ ${regex} ]]
}

@test "Collection-message: error" {
    regex="^.*(A message \!)$"

    verbose false
    [ -z "$(_ error "A message !")" ]

    verbose true
    [[ "$((_ error "A message !") 2>&1)" =~ ${regex} ]]
}

