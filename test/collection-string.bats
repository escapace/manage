#!/usr/bin/env bats

load test_helper
load "$BATS_PARENT_DIRNAME"/common/collection-string

@test "CamelCase" {
  result="$(echo "camel_case" | _camel)"
  [ "$result" = "CamelCase" ]
}

@test "Capitalize" {
  result="$(echo "capitalize" | _capitalize)"
  [ "$result" = "Capitalize" ]
}

@test "Commonprefix" {
  result="$(echo -e "spam\nspace"   | _commonprefix)"
  [ "$result" = "spa" ]
}

@test "Commonsuffix" {
  result="$(echo -e "foobar\nbabar" | _commonsuffix)"
  [ "$result" = "bar" ]
}

#TODO: detox

@test "Join Lines" {
  result="$(echo -e "foo\nbar\nbaz" | _joinLines)"
  [ "$result" = "foo, bar, baz" ]
}

@test "Lower" {
  result="$(echo "LoWeR" | _lower)"
  [ "$result" = "lower" ]
}

