#!/usr/bin/env bats

load test_helper
import collection-string
fixtures collection-string

@test "Collection-string: CamelCase" {
  result="$(echo "camel_case" | _camel)"
  [ "$result" = "CamelCase" ]
}

@test "Collection-string: Capitalize" {
  result="$(echo "capitalize" | _capitalize)"
  [ "$result" = "Capitalize" ]
}

@test "Collection-string: Common Prefix" {
  result="$(echo -e "spam\nspace"   | _commonprefix)"
  [ "$result" = "spa" ]
}

@test "Collection-string: Common Suffix" {
  result="$(echo -e "foobar\nbabar" | _commonsuffix)"
  [ "$result" = "bar" ]
}

@test "Collection-string: Detox" {
  result="$(echo -e " qwe%&^" | _detox)"
  [ "$result" = "qwe" ]
}

@test "Collection-string: Join Lines" {
  result="$(echo -e "foo\nbar\nbaz" | _joinLines)"
  [ "$result" = "foo, bar, baz" ]
}

@test "Collection-string: Lower" {
  result="$(echo "LoWeR" | _lower)"
  [ "$result" = "lower" ]
}

@test "Collection-string: Snake" {
  result="$(echo "foo bar" | _snake)"
  [ "$result" = "foo_bar" ]
}

@test "Collection-string: Sort List" {
  result="$(echo "c b b b a" | _sortList -u)"
  [ "$result" = "a b c" ]
}

@test "Collection-string: Split String" {
  result="$(echo "foo, bar, baz" | _splitString)"
  string="$(echo -e "foo\nbar\nbaz")"
  [ "$result" =  "$string" ]
}

@test "Collection-string: Squeeze" {
  result="$(echo "  foo  bar   baz  " | _squeeze)"
  [ "$result" = "foo bar baz" ]
}

@test "Collection-string: Squeeze Lines" {
  expected="$(cat "${FIXTURE_ROOT}/squeezeLines/expected")"
  result="$(cat "${FIXTURE_ROOT}/squeezeLines/input" | _squeezeLines)"
  [ "$result" = "${expected}" ]
}

@test "Collection-string: Trim" {
  result="$(echo "  foo  bar baz  " | _trim)"
  [ "$result" = "foo  bar baz" ]
}

@test "Collection-string: Trim Left" {
  result="$(echo "  foo  bar baz  " | _trimLeft)"
  [ "$result" = "foo  bar baz  " ]
}

@test "Collection-string: Trim Right" {
  result="$(echo "  foo  bar baz  " | _trimRight)"
  [ "$result" = "  foo  bar baz" ]
}

@test "Collection-string: Trim Right" {
  result="$(echo "  foo  bar baz  " | _trimRight)"
  [ "$result" = "  foo  bar baz" ]
}

@test "Collection-string: Trim Lines" {
  expected="$(cat "${FIXTURE_ROOT}/trimLines/expected")"
  result="$(cat "${FIXTURE_ROOT}/trimLines/input" | _trimLines)"
  [ "$result" = "${expected}" ]
}

@test "Collection-string: Upper" {
  result="$(echo "foo" | _upper)"
  [ "$result" = "FOO" ]
}

@test "Collection-string: Wrap" {
  expected="$(cat "${FIXTURE_ROOT}/wrap/expected")"
  result="$(cat "${FIXTURE_ROOT}/wrap/input" | _wrap)"
  [ "$result" = "${expected}" ]
}

