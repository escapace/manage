#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-string"
fixtures collection-string

@test "Collection-string: CamelCase" {
  result="$(echo "camel_case" | _ camel)"
  [ "$result" = "CamelCase" ]
}

@test "Collection-string: Capitalize" {
  result="$(echo "capitalize" | _ capitalize)"
  [ "$result" = "Capitalize" ]
}

@test "Collection-string: Common Prefix" {
  result="$(echo -e "spam\nspace"   | _ commonprefix)"
  [ "$result" = "spa" ]
}

@test "Collection-string: Common Suffix" {
  result="$(echo -e "foobar\nbabar" | _ commonsuffix)"
  [ "$result" = "bar" ]
}

@test "Collection-string: Detox" {
  result="$(echo -e " qwe%&^" | _ detox)"
  [ "$result" = "qwe" ]
}

@test "Collection-string: Join Lines" {
  result="$(echo -e "foo\nbar\nbaz" | _ joinLines)"
  [ "$result" = "foo, bar, baz" ]
}

@test "Collection-string: Lower" {
  result="$(echo "LoWeR" | _ lower)"
  [ "$result" = "lower" ]
}

@test "Collection-string: Snake" {
  result="$(echo "foo bar" | _ snake)"
  [ "$result" = "foo_bar" ]
}

@test "Collection-string: Sort List" {
  result="$(echo "c b b b a" | _ sortList -u)"
  [ "$result" = "a b c" ]
}

@test "Collection-string: Split String" {
  result="$(echo "foo, bar, baz" | _ splitString)"
  string="$(echo -e "foo\nbar\nbaz")"
  [ "$result" =  "$string" ]
}

@test "Collection-string: Squeeze" {
  result="$(echo "  foo  bar   baz  " | _ squeeze)"
  [ "$result" = "foo bar baz" ]
}

@test "Collection-string: Squeeze Lines" {
  expected="$(cat "${FIXTURE_ROOT}/squeezeLines/expected")"
  result="$(cat "${FIXTURE_ROOT}/squeezeLines/input" | _ squeezeLines)"
  [ "$result" = "${expected}" ]
}

@test "Collection-string: Trim" {
  result="$(echo "  foo  bar baz  " | _ trim)"
  [ "$result" = "foo  bar baz" ]
}

@test "Collection-string: Trim Left" {
  result="$(echo "  foo  bar baz  " | _ trimLeft)"
  [ "$result" = "foo  bar baz  " ]
}

@test "Collection-string: Trim Right" {
  result="$(echo "  foo  bar baz  " | _ trimRight)"
  [ "$result" = "  foo  bar baz" ]
}

@test "Collection-string: Trim Right" {
  result="$(echo "  foo  bar baz  " | _ trimRight)"
  [ "$result" = "  foo  bar baz" ]
}

@test "Collection-string: Trim Lines" {
  expected="$(cat "${FIXTURE_ROOT}/trimLines/expected")"
  result="$(cat "${FIXTURE_ROOT}/trimLines/input" | _ trimLines)"
  [ "$result" = "${expected}" ]
}

@test "Collection-string: Upper" {
  result="$(echo "foo" | _ upper)"
  [ "$result" = "FOO" ]
}

@test "Collection-string: Wrap" {
  expected="$(cat "${FIXTURE_ROOT}/wrap/expected")"
  result="$(cat "${FIXTURE_ROOT}/wrap/input" | _ wrap)"
  [ "$result" = "${expected}" ]
}

