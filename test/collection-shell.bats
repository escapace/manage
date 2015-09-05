#!/usr/bin/env bats

load test_helper
import collection-shell
fixtures collection-shell

#TODO: Execute In

@test "First" {
  a=""
  b="asd"
  result="$(_first "$a" "$b")"
  [ "$result" = "asd" ]
}

@test "Named" {
    some_var="The value I really want"
    result="$(_named "some_var")"
    [ "$result" = "The value I really want" ]
}

@test "Truth" {
    _truth True          #==> true
    _truth 1             #==> true
    _truth on            #==> true
    _truth spam  || true #==> false
    _truth false || true #==> false
    _truth       || true #==> false
}

@test "Truth Echo" {
    result="$(_truthEcho true "first" "second")"
    [ "$result" = "first" ]
    result="$(_truthEcho false "first" "second")"
    [ "$result" = "second" ]
}

@test "Truth Vaule" {
    result="$(_truthValue true)"
    [ "$result" = "1" ]
    result="$(_truthValue false)"
    [ "$result" = "0" ]
}

@test "Execute" {
  script="${FIXTURE_ROOT}/execute/hello"
  result="$(_execute "${script}")"
  [ "$result" = "Hello World" ]
}

@test "Repeat" {
    result="$(_repeat 3 echo -n asd )"
    [ "$result" = "asdasdasd" ]
}

@test "Required" {
    qwe="qwe"
    space=" "
    bsd=""
    _required "${qwe}"
    _required "${asd}"   || true
    _required "${space}" || true
    _required "${bsd}"   || true
    _required "${qwe}" "${asd}" || true
    _required "${asd}" "${qwe}" || true
}

@test "Exists" {
    arrayTrue=("bash" "mkdir" "ls" "rm" "cat")
    arrayFalse=("bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln")

    __exists "bash"
    __exists "6e8fe0f63ffbb20d6d202d5520f5051c" || true

    _exists || true
    _exists "bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln" || true
    _exists "bash" "mkdir" "ls" "rm" "cat"
    _exists "${arrayTrue[@]}"
    _exists "${arrayFalse[@]}" || true

    result="$(_exists "${arrayFalse[@]}" || echo "${arrayFalse[$?]}")"
    [ "$result" = "6e8fe0f63ffbb20d6d202d5520f5051c" ]
}

