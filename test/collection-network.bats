#!/usr/bin/env bats

load test_helper
import collection-network
fixtures collection-network

argumentone="10.8.30.57/25"

@test "Collection-network: Get address from CIDR." {
    test="address"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.57" ]]
}

@test "Collection-network: Get netmask from CIDR." {
    test="netmask"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "255.255.255.128" ]]
}

@test "Collection-network: Get prefix from CIDR." {
    test="prefix"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "25" ]]
}

@test "Collection-network: Get network from CIDR." {
    test="network"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.0/25" ]]
}

@test "Collection-network: Get hostmin from CIDR." {
    test="hostmin"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.1" ]]
}

@test "Collection-network: Get hostmax from CIDR." {
    test="hostmax"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.126" ]]
}

@test "Collection-network: Get broadcast from CIDR." {
    test="broadcast"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.127" ]]
}

@test "Collection-network: Get hosts from CIDR." {
    test="hosts"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "126" ]]
}


@test "Collection-network: Get range from CIDR." {
    test="range"
    expected="${FIXTURE_ROOT}/range/expected"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "$(cat "${expected}")" ]]
}

argumentone="10.8.30.57"
argumenttwo="255.255.255.128"

@test "Collection-network: Get address from IP and Netmask." {
    test="address"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.57" ]]
}

@test "Collection-network: Get netmask from IP and Netmask." {
    test="netmask"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "255.255.255.128" ]]
}

@test "Collection-network: Get prefix from IP and Netmask." {
    test="prefix"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "25" ]]
}

@test "Collection-network: Get network from IP and Netmask." {
    test="network"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.0/25" ]]
}

@test "Collection-network: Get hostmin from IP and Netmask." {
    test="hostmin"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.1" ]]
}

@test "Collection-network: Get hostmax from IP and Netmask." {
    test="hostmax"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.126" ]]
}

@test "Collection-network: Get broadcast from IP and Netmask." {
    test="broadcast"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.127" ]]
}

@test "Collection-network: Get hosts from IP and Netmask." {
    test="hosts"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "126" ]]
}

@test "Collection-network: Get range from IP and Netmask." {
    test="range"
    expected="${FIXTURE_ROOT}/range/expected"
    result="$(_ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "$(cat "${expected}")" ]]
}
