#!/usr/bin/env bats

load test-helper-generic

@test "Shellshock: CVE-2014-6271" {
    result=$(env 'x=() { :;}; echo vulnerable' 'BASH_FUNC_x()=() { :;}; echo vulnerable' bash -c "echo test" 2>&1 | grep 'vulnerable' | wc -l)
    return "${result}"
}

@test "Shellshock: CVE-2014-6277" {
    result=$((shellshocker="() { x() { _;}; x() { _;} <<a; }" bash -c date 2>/dev/null || echo vulnerable) | grep 'vulnerable' | wc -l)
    return "${result}"
}

@test "Shellshock: CVE-2014-6278" {
    result=$(shellshocker='() { echo vulnerable; }' bash -c shellshocker 2>/dev/null | grep 'vulnerable' | wc -l)
    return "${result}"
}

@test "Shellshock: CVE-2014-7169" {
    result=$((cd /tmp; rm -f /tmp/echo; env X='() { (a)=>\' bash -c "echo echo nonvuln" 2>/dev/null; [[ "$(cat echo 2> /dev/null)" == "nonvuln" ]] && echo "vulnerable" 2> /dev/null) | grep 'vulnerable' | wc -l)
    return "${result}"
}

@test "Shellshock: CVE-2014-7186" {
    result=$((bash -c 'true <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF <<EOF' 2>/dev/null || echo "vulnerable") | grep 'vulnerable' | wc -l)
    return "${result}"
}

@test "Shellshock: CVE-2014-7187" {
    result=$(((for x in {1..200}; do echo "for x$x in ; do :"; done; for x in {1..200}; do echo done; done) | bash || echo "vulnerable") | grep 'vulnerable' | wc -l)
    return "${result}"
}

@test "Shellshock: CVE-2014-////" {
    result=$(env X=' () { }; echo vulnerable' bash -c 'date' | grep 'vulnerable' | wc -l)
    return "${result}"
}
