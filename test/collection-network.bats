#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-network"
fixtures collection-network

argumentone="10.8.30.57/25"

@test "Collection-network: Get address from CIDR." {
    test="address"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.57" ]]
}

@test "Collection-network: Get netmask from CIDR." {
    test="netmask"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "255.255.255.128" ]]
}

@test "Collection-network: Get prefix from CIDR." {
    test="prefix"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "25" ]]
}

@test "Collection-network: Get network from CIDR." {
    test="network"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.0/25" ]]
}

@test "Collection-network: Get hostmin from CIDR." {
    test="hostmin"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.1" ]]
}

@test "Collection-network: Get hostmax from CIDR." {
    test="hostmax"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.126" ]]
}

@test "Collection-network: Get broadcast from CIDR." {
    test="broadcast"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.127" ]]
}

@test "Collection-network: Get hosts from CIDR." {
    test="hosts"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "126" ]]
}


@test "Collection-network: Get range from CIDR." {
    test="range"
    expected="${FIXTURE_ROOT}/range/expected"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "$(cat "${expected}")" ]]
}

argumentone="10.8.30.57"
argumenttwo="255.255.255.128"

@test "Collection-network: Get address from IP and Netmask." {
    test="address"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.57" ]]
}

@test "Collection-network: Get netmask from IP and Netmask." {
    test="netmask"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "255.255.255.128" ]]
}

@test "Collection-network: Get prefix from IP and Netmask." {
    test="prefix"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "25" ]]
}

@test "Collection-network: Get network from IP and Netmask." {
    test="network"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.0/25" ]]
}

@test "Collection-network: Get hostmin from IP and Netmask." {
    test="hostmin"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.1" ]]
}

@test "Collection-network: Get hostmax from IP and Netmask." {
    test="hostmax"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.126" ]]
}

@test "Collection-network: Get broadcast from IP and Netmask." {
    test="broadcast"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "10.8.30.127" ]]
}

@test "Collection-network: Get hosts from IP and Netmask." {
    test="hosts"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "126" ]]
}

@test "Collection-network: Get range from IP and Netmask." {
    test="range"
    expected="${FIXTURE_ROOT}/range/expected"
    result="$(_ ipcalc "${test}" "${argumentone}" "${argumenttwo}")"
    [[ "${result}" == "$(cat "${expected}")" ]]
}
