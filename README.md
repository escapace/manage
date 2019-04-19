# manage

[![build status][2]][1]
[![license][3]]()

`manage` is an MPLv2 licensed framework for building modular Bash
applications.

## Table of Contents

-   [Usage](#usage)
    -   [Setup](#setup)
    -   [Commands and Modules](#commands-and-modules)
    -   [Built-in statements](#built-in-statements)
    -   [Utility Library](#utility-library)
    -   [Remote Modules](#remote-modules)
-   [Acknowledgements](#acknowledgements)
-   [License](#license)

## Usage

In this example, we’ll use `manage` as a submodule. We’ll go through
the setup process; learn the distinction between commands and modules;
and describe built-in statements.

### Setup

Let’s make a temporary directory, initialize a git project and add a
directory to it (vendor, in this case).

```bash
$ mkdir tmp
$ cd tmp
$ mkdir vendor
```

Add `manage` as a submodule

```bash
$ git submodule add https://github.com/escapace/manage vendor/manage
```

Run the initialization script

```bash
$ ./vendor/manage/manage init
```

This will set up directories inside `tmp` as follows

```bash
INFO Creating scripts directory /path/to/tmp/scripts
INFO Creating modules directory /path/to/tmp/scripts/modules
```

Running `ls -a` in `tmp`, we should now get

```bash
.  ..  scripts  manage  .manage.yml
```

Note that these paths are customizable in the `.manage.yml` file.

### Commands and Modules

Commands are scripts local to the project. Modules are reusable bash functions
that can be imported from commands in local and remote projects.

#### Commands

-   Contain [`@dependency`][29] [`@description`][30] and [`@import`][31]
    statements
-   When importing modules, need to prefix them with an underscore

#### Modules

-   Contain only [`@import`][31] statements
-   Must have only 1 function
-   File name must be the same as the bash function name it exposes
-   Must not prefix imported modules with an underscore
-   Should be placed in `scripts/modules/arbitrary-directory/moduleName`

### Built-in statements

#### @description

```sh
# @description capitalize and print string
```

Provides a short description of a script which will be logged when `./manage` is called

#### @dependency

```bash
# @dependency docker
```

Checks whether executable with given name exists in **PATH**

#### @import

```bash
# @import github.com/escapace/stack-tools download/downloadPacker
```

Import a module from import path.

-   Modules from manage utility library such as `array/join`
-   Local modules in `scripts/modules` directory
-   Remote modules such as `github.com/escapace/stack-tools download/downloadPacker`

### Utility Library

Manage contains utility modules for Bash, resembling those of lodash.
Utility module groups include

-   [array][5]
-   [console][6]
-   [lang][7]
-   [manage][8]
-   [path][9]
-   [string][10]

Let’s import and use one of these. In `scripts` there is a file called
`hello`. It already uses `warn` and `error` modules

```bash
# @import console/warn
# @import console/error
```

Imported modules should be prefixed with underscore, hence

```bash
if (( $1 == 0 ))
then
    _ warn "Exiting."
else
    _ error "An error with exit code \"$1\" has occurred."
fi
```

We import `string/capitalize`, which, not surprisingly, capitalizes a
string.

```bash
# @import string/capitalize
```

Then we add the following to `main ()`

```bash
local string="lorem"
_ capitalize "${string}"
```

Now, if we run

```bash
$ ./manage hello
```

The result will be

    Hello World!
    Script name: hello
    Caller name: manage
    Repository : path/to/tmp
    PWD        : path/to/tmp
    Argument 1 :
    Argument 2 :
    Argument 3 :
    Lorem
    WARN Exiting.

Notice on line 9, “lorem” is capitalized to “Lorem”.

### Remote Modules

An import path can describe how to obtain the module source code from a GitHub
repository. The GitHub repository should have at least one signed version tag
(like v1.8.5). Say we want to import a manage module from the
[escapace/stack-tools][11] repository that automates the download and
verification of Hashicorp’s [Terraform][12].

In order to verify the [escapace/stack-tools][11] repository, we need to have
the escapace public key.

```bash
$ gpg2 --keyserver ha.pool.sks-keyservers.net --recv-key 13F26F82E955B8B8CE469054F29CCEBC83FD4525
```

Now, we can import the script by adding the following line to our `hello` file
in `scripts`

```bash
# @import github.com/escapace/stack-tools download/downloadTerraform
```

Then run

```bash
$ ./manage hello
```

This will execute the script and create a `.manage_modules` directory
containing our imports. If we run `ls -a` in `tmp`, we should get

```bash
.  .. .git  .manage_modules  scripts  vendor  .gitmodules  manage  .manage.yml
```

`vendor/terraform` now contains HashiCorp’s Terraform, which is ready
for usage.

## Acknowledgements

Our thanks go out to the developers and organizations who have directly and
indirectly contributed to this project.

-   [Jeremy Cantrell][14], [bashful][13] collection of libraries that simplify writing bash
    scripts
-   [Justin Dorfman][16] and [Joshua Mervine][17], [shml][15] terminal style framework
-   [Christian Couder][19], [Mathias Lafeldt][20] and contributors, [sharness][18] test library

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the MPL 2.0.

This program uses third-party libraries or other resources that may be
distributed under different licenses. Please refer to the specific
files and/or packages for more detailed information about the authors,
copyright notices, and licenses.

[1]: https://travis-ci.org/escapace/manage

[2]: https://secure.travis-ci.org/escapace/manage.png

[3]: https://img.shields.io/badge/license-Mozilla%20Public%20License%20Version%202.0-blue.svg

[4]: #built-in-statements

[5]: https://github.com/escapace/manage/tree/master/modules/array

[6]: https://github.com/escapace/manage/tree/master/modules/console

[7]: https://github.com/escapace/manage/tree/master/modules/lang

[8]: https://github.com/escapace/manage/tree/master/modules/manage

[9]: https://github.com/escapace/manage/tree/master/modules/path

[10]: https://github.com/escapace/manage/tree/master/modules/string

[11]: https://github.com/escapace/stack-tools

[12]: https://www.terraform.io/

[13]: https://github.com/jmcantrell/bashful

[14]: https://github.com/jmcantrell

[15]: https://github.com/MaxCDN/shml

[16]: https://github.com/jdorfman

[17]: https://github.com/jmervine

[18]: https://github.com/chriscool/sharness

[19]: https://github.com/chriscool

[20]: https://twitter.com/mlafeldt

[22]: #usage

[23]: #setup

[24]: #commands-and-modules

[25]: #utility-library

[26]: #remote-modules

[27]: #acknowledgements

[28]: #license

[29]: #dependency

[30]: #description

[31]: #import
