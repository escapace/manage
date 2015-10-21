#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-shell"
fixtures collection-shell

@test "Collection-shell: First" {
  a=""
  b="asd"
  result="$(_ first "$a" "$b")"
  [ "$result" = "asd" ]
}

@test "Collection-shell: Named" {
    some_var="The value I really want"
    result="$(_ named "some_var")"
    [ "$result" = "The value I really want" ]
}

@test "Collection-shell: Truth" {
    _ truth True          #==> true
    _ truth 1             #==> true
    _ truth on            #==> true
    _ truth spam  || true #==> false
    _ truth false || true #==> false
    _ truth       || true #==> false
}

@test "Collection-shell: Truth Echo" {
    result="$(_ truthEcho true "first" "second")"
    [ "$result" = "first" ]
    result="$(_ truthEcho false "first" "second")"
    [ "$result" = "second" ]
}

@test "Collection-shell: Truth Vaule" {
    result="$(_ truthValue true)"
    [ "$result" = "1" ]
    result="$(_ truthValue false)"
    [ "$result" = "0" ]
}

@test "Collection-shell: Execute" {
  script="${FIXTURE_ROOT}/execute/hello"
  result="$(_ execute "${script}")"
  [ "$result" = "Hello World" ]
}

@test "Collection-shell: ExecuteIn" {
  cd "${TMP}"
  script="${FIXTURE_ROOT}/execute/pwd"
  result="$(_ execute "${script}")"
  [ "$result" = "${TMP}" ]
}

@test "Collection-shell: Repeat" {
    result="$(_ repeat 3 echo -n asd )"
    [ "$result" = "asdasdasd" ]
}

@test "Collection-shell: Required" {
    qwe="qwe"
    space=" "
    bsd=""
    _ required "${qwe}"
    _ required "${asd}"   || true
    _ required "${space}" || true
    _ required "${bsd}"   || true
    _ required "${qwe}" "${asd}" || true
    _ required "${asd}" "${qwe}" || true
}

@test "Collection-shell: Exists" {
    arrayTrue=("bash" "mkdir" "ls" "rm" "cat")
    arrayFalse=("bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln")

    _ exists
    _ exists "bash" "mkdir" "ls" "rm" "cat" "6e8fe0f63ffbb20d6d202d5520f5051c" "ln" || [[ $? == "6" ]]
    _ exists "bash" "mkdir" "ls" "rm" "cat"
    _ exists "bash" "qweasd" || [[ $? == "2" ]]
    _ exists "qweasd" "bash" || [[ $? == "1" ]]

    _ exists "${arrayTrue[@]}"
    _ exists "${arrayFalse[@]}" || [[ $? == "6" ]]

    result="$(_ exists "${arrayFalse[@]}" || echo "${arrayFalse[$(($?-1))]}")"
    [ "$result" = "6e8fe0f63ffbb20d6d202d5520f5051c" ]
}

