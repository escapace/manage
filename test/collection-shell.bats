#!/usr/bin/env bats

load test_helper
import collection-shell
fixtures collection-shell

@test "Collection-shell: First" {
  a=""
  b="asd"
  result="$(_first "$a" "$b")"
  [ "$result" = "asd" ]
}

@test "Collection-shell: Named" {
    some_var="The value I really want"
    result="$(_named "some_var")"
    [ "$result" = "The value I really want" ]
}

@test "Collection-shell: Truth" {
    _truth True          #==> true
    _truth 1             #==> true
    _truth on            #==> true
    _truth spam  || true #==> false
    _truth false || true #==> false
    _truth       || true #==> false
}

@test "Collection-shell: Truth Echo" {
    result="$(_truthEcho true "first" "second")"
    [ "$result" = "first" ]
    result="$(_truthEcho false "first" "second")"
    [ "$result" = "second" ]
}

@test "Collection-shell: Truth Vaule" {
    result="$(_truthValue true)"
    [ "$result" = "1" ]
    result="$(_truthValue false)"
    [ "$result" = "0" ]
}

@test "Collection-shell: Execute" {
  script="${FIXTURE_ROOT}/execute/hello"
  result="$(_execute "${script}")"
  [ "$result" = "Hello World" ]
}

@test "Collection-shell: ExecuteIn" {
  cd "${TMP}"
  script="${FIXTURE_ROOT}/execute/pwd"
  result="$(_execute "${script}")"
  [ "$result" = "${TMP}" ]
}

@test "Collection-shell: Repeat" {
    result="$(_repeat 3 echo -n asd )"
    [ "$result" = "asdasdasd" ]
}

@test "Collection-shell: Required" {
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

@test "Collection-shell: Exists" {
    arrayTrue=("bash" "mkdir" "ls" "rm" "cat")
    arrayFalse=("bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln")

    __exists "bash"
    __exists "6e8fe0f63ffbb20d6d202d5520f5051c" || true

    _exists || true
    _exists "bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln" || true
    _exists "bash" "mkdir" "ls" "rm" "cat"
    _exists "${arrayTrue[@]}"
    _exists "${arrayFalse[@]}" || true

    result="$(_exists "${arrayFalse[@]}" || echo "${arrayFalse[$(($?-1))]}")"
    [ "$result" = "6e8fe0f63ffbb20d6d202d5520f5051c" ]
}

