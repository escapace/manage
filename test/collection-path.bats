#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-path"
# fixtures collection-path

@test "Collection-path: commonpath" {
  expected="/foo/bar"
  result="$(_ commonpath "/foo/bar/baz" "/foo/bar/qwe")"
  [ "$result" = "${expected}" ]
}

@test "Collection-path: commontail" {
  expected="bar/baz"
  result="$(_ commontail "/qwe/bar/baz" "/asd/bar/baz")"
  [ "$result" = "${expected}" ]
}

@test "Collection-path: abspath" {
  expected="${BATS_TEST_DIRNAME}"
  result="$(_ abspath "${BATS_TEST_DIRNAME}")"
  [ "$result" = "${expected}" ]
}

@test "Collection-path: relpath" {
  cd "${BATS_TEST_DIRNAME}"
  expected="."
  result="$(_ relpath "${BATS_TEST_DIRNAME}")"
  [ "$result" = "${expected}" ]
}
