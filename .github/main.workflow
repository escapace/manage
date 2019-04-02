workflow "Docker" {
  on = "push"
  resolves = ["Docker Push A", "Docker Push B"]
}

action "Filter" {
  uses = "actions/bin/filter@3c98a2679187369a2116d4f311568596d3725740"
  runs = "tag v*"
}

action "Docker Login" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = ["DOCKER_PASSWORD", "DOCKER_USERNAME"]
  needs = ["Filter"]
}

action "Docker Build" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build --squash -t escapace/manage:latest -t escapace/manage:${GITHUB_REF:11} ."
  needs = ["Filter"]
}

action "Docker Push A" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Build", "Docker Login"]
  args = "push escapace/manage:latest"
  secrets = ["DOCKER_PASSWORD", "DOCKER_USERNAME"]
}

action "Docker Push B" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Build", "Docker Login"]
  secrets = ["DOCKER_PASSWORD", "DOCKER_USERNAME"]
  args = "push escapace/manage:${GITHUB_REF:11}"
}
