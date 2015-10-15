<p align="right">
    <a href="https://travis-ci.org/eitherlands/manage">
        <img src="https://travis-ci.org/eitherlands/manage.svg?branch=master"
             alt="build status">
    </a>
</p>

# manage

manage is a model for setting up shell programs that use subcommands.

# Tab completion

To enable tasks auto-completion in shell you should add `eval "$(manage completion shell)"` in your `.shellrc` file.

## Bash

Add `eval "$(manage completion bash)"` to `~/.bashrc`.

## Zsh

Add `eval "$(manage completion zsh)"` to `~/.zshrc`.

## Fish

Add `manage completion fish | source` to `~/.config/fish/config.fish`.
