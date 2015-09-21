#!/usr/bin/env bats

load test_helper
import collection-grammar
fixtures collection-grammar

@test "Collection-grammar: Actions File" {
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(_actions "qwe_" "${FIXTURE_ROOT}/actions/input")"
  echo "${result}"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Actions stdin" {
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(cat "${FIXTURE_ROOT}/actions/input" | _actions "qwe_")"
  echo "${result}"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Actions Stack" {
  load "${FIXTURE_ROOT}/actions/input"
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(_actions "qwe_")"
  echo "${result}"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Functions" {
  expected="$(cat "${FIXTURE_ROOT}/functions/expected")"
  result="$(_functions "${FIXTURE_ROOT}/functions/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Functions sdtin" {
  expected="$(cat "${FIXTURE_ROOT}/functions/expected")"
  result="$(cat "${FIXTURE_ROOT}/functions/input" | _functions)"
  [ "$result" = "${expected}" ]
}


@test "Collection-grammar: Embedded Range" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedRange")"
  result="$(_embeddedRange '<qwe>' '</qwe>' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Embedded Tag" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedTag")"
  result="$(_embeddedTag 'qwe' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Embedded Eval" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedEval")"
  result="$(_embeddedEval 'qwe' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Variables" {
  expected="$(cat "${FIXTURE_ROOT}/variables/expected")"
  result="$(_variables "${FIXTURE_ROOT}/variables/input")"
  echo "$result"
  [ "$result" = "${expected}" ]
}

@test "Collection-grammar: Variables stdin" {
  expected="$(cat "${FIXTURE_ROOT}/variables/expected")"
  result="$(cat "${FIXTURE_ROOT}/variables/input" | _variables)"
  echo "$result"
  [ "$result" = "${expected}" ]
}
