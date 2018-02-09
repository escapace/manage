#!/usr/bin/env bash
# shellcheck disable=SC2016,SC1090,SC2034

source "${MANAGE_DIRECTORY}/manage"
FIXTURES="${SHARNESS_TEST_DIRECTORY}/fixtures"

MANAGE_UNDERSCORE \
    manage/yaml

MANAGE_BOOTSTRAP

dependencies=$'bash\nawk'

expectSuccess 'yaml' '
    eval "$(_ yaml "${FIXTURES}/yaml/simple.yml" yml)"

    [ "$(yml scripts)" == "script" ] &&
    [ "$(yml strict)"  == "true" ] &&
    [ "$(yml default)"  == "help" ] &&
    [ "$(yml env_bla)"  == "bla" ] &&
    [ "$(yml env_ipi)"  == "ipa" ] &&
    [ "$(yml one)"  == "asd zxc qwe" ] &&
    [ "$(yml two " ")"  == "asd zxc qwe" ] &&
    mustFail yml doesnotexits &&
    [ "$(yml dependencies)"  == "${dependencies}" ]
'

finish
