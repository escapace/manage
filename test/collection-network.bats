#!/usr/bin/env bats

load test_helper
import collection-network
fixtures collection-network

argumentone="10.8.30.57/25"

@test "MAC address" {
    result="$(_mac)"
    [[ "${result}" =~ ^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$ ]]
}

@test "address from cidr" {
    test="address"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.57" ]]
}

@test "netmask from cidr" {
    test="netmask"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "255.255.255.128" ]]
}

@test "prefix from cidr" {
    test="prefix"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "25" ]]
}

@test "network from cidr" {
    test="network"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.0/25" ]]
}

@test "hostmin from cidr" {
    test="hostmin"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.1" ]]
}

@test "hostmax from cidr" {
    test="hostmax"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.126" ]]
}

@test "broadcast from cidr" {
    test="broadcast"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.127" ]]
}

@test "hosts from cidr" {
    test="hosts"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "126" ]]
}


@test "range from cidr" {
    test="range"
    expected="${FIXTURE_ROOT}/range/expected"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "$(cat "${expected}")" ]]
}

argumentone="10.8.30.57"
argumenttwo="255.255.255.128"

@test "address from ip and netmask" {
    test="address"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.57" ]]
}

@test "netmask from ip and netmask" {
    test="netmask"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "255.255.255.128" ]]
}

@test "prefix from ip and netmask" {
    test="prefix"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "25" ]]
}

@test "network from ip and netmask" {
    test="network"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.0/25" ]]
}

@test "hostmin from ip and netmask" {
    test="hostmin"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.1" ]]
}

@test "hostmax from ip and netmask" {
    test="hostmax"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.126" ]]
}

@test "broadcast from ip and netmask" {
    test="broadcast"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.127" ]]
}

@test "hosts from ip and netmask" {
    test="hosts"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "126" ]]
}

@test "range from ip and netmask" {
    test="range"
    expected="${FIXTURE_ROOT}/range/expected"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "$(cat "${expected}")" ]]
}
