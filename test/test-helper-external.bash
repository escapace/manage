#!/usr/bin/env bash

source "${BATS_TEST_DIRNAME}/test-helper-generic.bash"

export BATSMANAGELIBEXEC="${BATS_PARENT_DIRNAME}/libexec"
unset MANAGEREPOSITORY
unset MANAGEDIRECTORY
