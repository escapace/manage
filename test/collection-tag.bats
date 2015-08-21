#!/usr/bin/env bats

load test_helper
import collection-tag
fixtures collection-tag

@test "Actions File" {
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(_actions "qwe_" "${FIXTURE_ROOT}/actions/input")"
  echo "${result}"
  [ "$result" = "${expected}" ]
}

@test "Actions stdin" {
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(cat "${FIXTURE_ROOT}/actions/input" | _actions "qwe_")"
  echo "${result}"
  [ "$result" = "${expected}" ]
}

@test "Actions Stack" {
  load "${FIXTURE_ROOT}/actions/input"
  expected="$(cat "${FIXTURE_ROOT}/actions/expected")"
  result="$(_actions "qwe_")"
  echo "${result}"
  [ "$result" = "${expected}" ]
}

@test "Functions" {
  expected="$(cat "${FIXTURE_ROOT}/functions/expected")"
  result="$(_functions "${FIXTURE_ROOT}/functions/input")"
  [ "$result" = "${expected}" ]
}

@test "Functions sdtin" {
  expected="$(cat "${FIXTURE_ROOT}/functions/expected")"
  result="$(cat "${FIXTURE_ROOT}/functions/input" | _functions)"
  [ "$result" = "${expected}" ]
}

@test "Embedded Range" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedRange")"
  result="$(_embeddedRange '<qwe>' '</qwe>' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Embedded Tag" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedTag")"
  result="$(_embeddedTag 'qwe' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Embedded Eval" {
  expected="$(cat "${FIXTURE_ROOT}/embedded/expectedEval")"
  result="$(_embeddedEval 'qwe' "${FIXTURE_ROOT}/embedded/input")"
  [ "$result" = "${expected}" ]
}

@test "Variables" {
  expected="$(cat "${FIXTURE_ROOT}/variables/expected")"
  result="$(_variables "${FIXTURE_ROOT}/variables/input")"
  echo "$result"
  [ "$result" = "${expected}" ]
}

@test "Variables stdin" {
  expected="$(cat "${FIXTURE_ROOT}/variables/expected")"
  result="$(cat "${FIXTURE_ROOT}/variables/input" | _variables)"
  echo "$result"
  [ "$result" = "${expected}" ]
}

@test "Mustache" {
  QWE="qwe"
  ASD="asd"
  ZXC="zxc"
  cp -f "${FIXTURE_ROOT}/mustache/input" "${TMP}/input"
  _mustache "${TMP}/input" QWE ASD ZXC
  expected="$(cat "${FIXTURE_ROOT}/mustache/expected")"
  result="$(cat "${TMP}/input")"
  [ -d "$TMP" ] && rm -f "$TMP"/*
  [ "$result" = "${expected}" ]
}
