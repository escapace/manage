#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-grammar"
fixtures collection-grammar

@test "Collection-grammar: Actions File" {
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(_ actions "qwe_" "${FIXTURE_ROOT}/actions/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Actions stdin" {
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(cat "${FIXTURE_ROOT}/actions/input" | _ actions "qwe_")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Actions Stack" {
  load "${FIXTURE_ROOT}/actions/input"
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(_ actions "qwe_")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Functions" {
  expected="$(cat "${FIXTURE_ROOT}/functions/expected")"
  result="$(_ functions "${FIXTURE_ROOT}/functions/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Functions sdtin" {
  expected="$(cat "${FIXTURE_ROOT}/functions/expected")"
  result="$(cat "${FIXTURE_ROOT}/functions/input" | _ functions)"
  [ "$result" = "${expected}" ]
}


@test "Collection-grammar: Embedded Range" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedRange")"
  result="$(_ embeddedRange '<qwe>' '</qwe>' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Embedded Tag" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedTag")"
  result="$(_ embeddedTag 'qwe' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Embedded Eval" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedEval")"
  result="$(_ embeddedEval 'qwe' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Variables" {
  expected="$(cat "${FIXTURE_ROOT}/variables/expected")"
  result="$(_ variables "${FIXTURE_ROOT}/variables/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Variables stdin" {
  expected="$(cat "${FIXTURE_ROOT}/variables/expected")"
  result="$(cat "${FIXTURE_ROOT}/variables/input" | _ variables)"
  [ "$result" = "${expected}" ]
}
