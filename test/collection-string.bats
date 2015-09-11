#!/usr/bin/env bats

load test_helper
import collection-string
fixtures collection-string

@test "CamelCase" {
  result="$(echo "camel_case" | _camel)"
  [ "$result" = "CamelCase" ]
}

@test "Capitalize" {
  result="$(echo "capitalize" | _capitalize)"
  [ "$result" = "Capitalize" ]
}

@test "Common Prefix" {
  result="$(echo -e "spam\nspace"   | _commonprefix)"
  [ "$result" = "spa" ]
}

@test "Common Suffix" {
  result="$(echo -e "foobar\nbabar" | _commonsuffix)"
  [ "$result" = "bar" ]
}

@test "Detox" {
  result="$(echo -e " qwe%&^" | _detox)"
  [ "$result" = "qwe" ]
}

@test "Join Lines" {
  result="$(echo -e "foo\nbar\nbaz" | _joinLines)"
  [ "$result" = "foo, bar, baz" ]
}

@test "Lower" {
  result="$(echo "LoWeR" | _lower)"
  [ "$result" = "lower" ]
}

@test "Snake" {
  result="$(echo "foo bar" | _snake)"
  [ "$result" = "foo_bar" ]
}

@test "Sort List" {
  result="$(echo "c b b b a" | _sortList -u)"
  [ "$result" = "a b c" ]
}

@test "Split String" {
  result="$(echo "foo, bar, baz" | _splitString)"
  string="$(echo -e "foo\nbar\nbaz")"
  [ "$result" =  "$string" ]
}

@test "Squeeze" {
  result="$(echo "  foo  bar   baz  " | _squeeze)"
  [ "$result" = "foo bar baz" ]
}

@test "Squeeze Lines" {
  expected="$(cat "${FIXTURE_ROOT}/squeezeLines/expected")"
  result="$(cat "${FIXTURE_ROOT}/squeezeLines/input" | _squeezeLines)"
  [ "$result" = "${expected}" ]
}

@test "Trim" {
  result="$(echo "  foo  bar baz  " | _trim)"
  [ "$result" = "foo  bar baz" ]
}

@test "Trim Left" {
  result="$(echo "  foo  bar baz  " | _trimLeft)"
  [ "$result" = "foo  bar baz  " ]
}

@test "Trim Right" {
  result="$(echo "  foo  bar baz  " | _trimRight)"
  [ "$result" = "  foo  bar baz" ]
}

@test "Trim Right" {
  result="$(echo "  foo  bar baz  " | _trimRight)"
  [ "$result" = "  foo  bar baz" ]
}

@test "Trim Lines" {
  expected="$(cat "${FIXTURE_ROOT}/trimLines/expected")"
  result="$(cat "${FIXTURE_ROOT}/trimLines/input" | _trimLines)"
  [ "$result" = "${expected}" ]
}

@test "Upper" {
  result="$(echo "foo" | _upper)"
  [ "$result" = "FOO" ]
}

@test "Wrap" {
  expected="$(cat "${FIXTURE_ROOT}/wrap/expected")"
  result="$(cat "${FIXTURE_ROOT}/wrap/input" | _wrap)"
  [ "$result" = "${expected}" ]
}

