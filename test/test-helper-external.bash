#!/usr/bin/env bash

source "${BATS_TEST_DIRNAME}/test-helper-generic.bash"

export BATSMANAGELIBEXEC="${BATS_PARENT_DIRNAME}/libexec"
export BATSMANAGEDIRECTORY="${BATS_PARENT_DIRNAME}"

unset MANAGEREPOSITORY
unset MANAGEDIRECTORY
