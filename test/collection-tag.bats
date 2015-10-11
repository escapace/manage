#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-tag"
fixtures collection-tag

@test "Collection-tag: Tag" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedTag")"
  result="$(_ tag 'qwe' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-tag: Tag Directly" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedRange")"
  result="$(_ _tag '<qwe>' '</qwe>' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

