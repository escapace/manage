#!/usr/bin/env bats

load test-helper-internal
__ namespace "_" "collection-yaml"
fixtures collection-yaml


@test "Collection-yaml: Yaml" {
    eval "$(_ yaml "${FIXTURE_ROOT}/test.yml" yml)"
    [ "$(yml scripts)" == "script" ]
    [ "$(yml strict)"  == "true" ]
    [ "$(yml default)"  == "help" ]
    [ "$(yml env_bla)"  == "bla" ]
    [ "$(yml env_ipi)"  == "ipa" ]
    [ "$(yml dependencies)"  == $'bash\nawk' ]
    [ "$(yml one)"  == "asd zxc qwe" ]
    [ "$(yml two ' ')"  == "asd zxc qwe" ]
}

