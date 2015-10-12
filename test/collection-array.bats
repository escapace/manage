#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-array"
fixtures collection-array

@test "Collection-array: Join" {
  aa=("a sd" "qwe" "z xc")
  expected="a sd|qwe|z xc"
  result="$(_ join aa "|")"
  [ "$result" = "${expected}" ]
}

@test "Collection-array: Includes" {
  aa=("a sd" "q we" "z xc")
  _ includes aa fgh || true
  _ includes aa "q we"
}

@test "Collection-array: IndexOf" {
  aa=("asd" "qwe" "zx c")
  result="$(_ indexOf aa "zx c")"
  expected="2"
  [ "$result" = "${expected}" ]
}

@test "Collection-array: forEach" {

  aa=("asd" "qwe" "zx c")
  result="$(_ forEach aa echo bla)"
  expected=$'0 bla\n1 bla\n2 bla'
  [ "$result" = "${expected}" ]
}

@test "Collection-array: Intersection" {
  aa=("asd" "q we" "zxc" "bb b")
  ab=("asdd" "q we" "z xcc" "bb b")
  result="$(_ intersection aa ab "|")"
  expected='q we|bb b'
  [ "$result" = "${expected}" ]
}

@test "Collection-array: Difference" {
  aa=("asd" "q we" "zx c" "bb b")
  ab=("asd" "q we" "zxc" "bb b b")
  result="$(_ difference aa ab "|")"
  expected='zx c|bb b|zxc|bb b b'
  [ "$result" = "${expected}" ]
}

@test "Collection-array: Complement" {
  aa=("asd" "q we" "zx c" "bb b")
  ab=("asd" "q we" "zxc" "bb b b")
  result="$(_ complement aa ab "|")"
  expected='zx c|bb b'
  [ "$result" = "${expected}" ]
}

@test "Collection-array: Union" {
  aa=("a" "b" "c" "d")
  ab=("e" "f" "g space" "h")
  result="$(_ union aa ab '|')"
  expected='a|b|c|d|e|f|g space|h'
  [ "$result" = "${expected}" ]
}
