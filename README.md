<p align="right">
    <a href="https://travis-ci.org/escapace/manage">
        <img src="https://travis-ci.org/escapace/manage.svg?branch=next"
             alt="build status">
    </a>
</p>

# [manage](https://github.com/escapace/manage)

`manage` is a convention for setting up shell programs that use subcommands.   

## Usage    

In this example we'll use `manage` as a submodule. We'll go through the setup process,  understand the distinction between commands and modules, describe built-in statements. We'll also see how `manage` can be used as a module manager.

### Setup
We make a temporary directory, initialize a git project and add a directory to it (vendor, in this case).

``` bash
$ mkdir tmp
$ cd tmp
$ mkdir vendor
```

Add `manage` as a submodule to vendor:

``` bash
$ git submodule add https://github.com/escapace/manage vendor/manage
```

Then we run the initialization script:

``` bash
$ ./vendor/manage/bin/manage init
```

This will set up directories inside `tmp` as follows:

``` bash
INFO Creating scripts directory /path/to/scripts
INFO Creating tests directory /path/to/scripts/tests
INFO Creating modules directory /path/to/scripts/modules
```

Running `ls` in `tmp`, we should now get:

``` bash
scripts vendor manage
```

Note that these paths are customizable from our `.manage.yml` file, which is in `vendor/manage`. 


### Commands and Modules

Commands are scripts local to the project (much like npm scripts). Modules are reusable bash functions that can be imported from commands in local and remote projects. There are differences between commands and modules.   

**Commands**: 

- contain [`@dependency`]() [`@description`]() and [`@import`]() statements 
- when importing modules, need to prefix them with an underscore _

**Modules**:  

- contain only [`@import`]() statements
- must have only 1 function
- file name must be the same as the bash function name it exposes
- when importing other modules, need not underscore those
- should be placed in `path/to/modules/directory/yourModule` 


### Built-in statements
**@description**
- *usage*: provides a short description for a script which will be logged when `./manage` is called
- *example*: 
```# @description capitalize and print string```

**@dependency**: 
- *usage*: checks whether executable with given name exists in **PATH**
- *example*: 
```# @dependency docker```   

**@import**:
- *usage*: imports / downloads other modules
- *example*: 
```# @import github.com/escapace/stack-tools/hashicorp/downloadPacker```


### Utility Library- are reusable scripts that can be imported from elsewhere. 

Manage contains utility modules for Bash, resembling those of lodash. Utility module groups include:

- [array](https://github.com/escapace/manage/tree/master/modules/array)
- [console](https://github.com/escapace/manage/tree/master/modules/console)
- [lang](https://github.com/escapace/manage/tree/master/modules/lang)
- [manage](https://github.com/escapace/manage/tree/master/modules/manage)
- [path](https://github.com/escapace/manage/tree/master/modules/path)
- [string](https://github.com/escapace/manage/tree/master/modules/string)

Let’s import and use one of these.   
In `scripts` there is a file called `hello`. It already uses `warn` and `error` modules:

    # @import console/warn
    # @import console/error

Imported modules should be prefixed with underscore, hence:

    if (( $1 == 0 ))
    then
        _ warn "Exiting."
    else
        _ error "An error with exit code \"$1\" has occurred."
    fi

We import `string/capitalize`, which, not surprisingly, capitalizes a string.

    # @import string/capitalize 

Then we add the following to `main()`:


    local string="lorem"
    _ capitalize $string

Now, if we run:

``` bash
$ ./manage hello
```

The result will be:

    Hello World!
    Script name: hello
    Caller name: manage
    Repository : /home/robadam/dev/tmp
    PWD        : /home/robadam/dev/tmp
    Argument 1 : 
    Argument 2 : 
    Argument 3 : 
    Lorem
    WARN Exiting.

Notice on line 9, “lorem” is capitalized to “Lorem”.


### Remote Imports

Manage can be used as a module manager.   
Say we want to import a script from [Escapace](https://github.com/escapace) that automates downloading and verifying the checksum of Hashicorp’s [Terraform](https://www.terraform.io/).   
First of all, we should secure our communications with Escapace:

``` bash
$ gpg2 --keyserver ha.pool.sks-keyservers.net --recv-key 13F26F82E955B8B8CE469054F29CCEBC83FD4525
```

Now, we can import the script by adding the following line to our `hello` file in `scripts`


    # @import github.com/escapace/stack-tools/hashicorp/downloadTerraform

Then run:

``` bash
$ ./manage hello
```

This will execute the script and create a `.manage_modules` directory containing your imports.   
If we run `ls -a` in `tmp`, we should get:


    .git  .manage_modules  scripts  vendor  .gitmodules  manage  .manage.yml

`.manage_modules` now contains Terraform, which is ready for usage.


## [Acknowledgements](https://github.com/escapace/manage#Acknowledgements)

We are very grateful to the following people and projects for their
contributions to this product:

* [bashful](https://github.com/jmcantrell/bashful) collection of libraries that
  simplify writing bash scripts ([Jeremy Cantrell](https://github.com/jmcantrell))

* [shml](https://github.com/MaxCDN/shml) terminal style framework
  ([Justin Dorfman](https://github.com/jdorfman) & [Joshua Mervine](https://github.com/jmervine))

* [sharness](https://github.com/chriscool/sharness) test library
  ([Christian Couder](https://github.com/chriscool), [Mathias Lafeldt](https://twitter.com/mlafeldt) & contributors)

## [License](https://github.com/escapace/manage#License)

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
