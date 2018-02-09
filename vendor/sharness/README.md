# sharness

Sharness is a portable shell library to write, run, and analyze automated tests
for Unix programs. Since all tests output TAP, the [Test Anything Protocol],
they can be run with any TAP harness.

Each test is written as a shell script, for example:

```sh
#!/bin/sh

description="Show basic features of Sharness"

. ./sharness.sh

expectSuccess "Success is reported like this" "
    echo hello world | grep hello
"

expectSuccess "Commands are chained this way" "
    test x = 'x' &&
    test 2 -gt 1 &&
    echo success
"

return_42() {
    echo "Will return soon"
    return 42
}

expectSuccess "You can test for a specific exit code" "
    expectCode 42 return_42
"

expectFailure "We expect this to fail" "
    test 1 = 2
"

finish
```

Running the above test script returns the following (TAP) output:

    $ ./simple.t
    ok 1 - Success is reported like this
    ok 2 - Commands are chained this way
    ok 3 - You can test for a specific exit code
    not ok 4 - We expect this to fail # TODO known breakage
    # still have 1 known breakage(s)
    # passed all remaining 3 test(s)
    1..4

Alternatively, you can run the test through [prove(1)]&#x3A;

    $ prove simple.t
    simple.t .. ok
    All tests successful.
    Files=1, Tests=4,  0 wallclock secs ( 0.02 usr +  0.00 sys =  0.02 CPU)
    Result: PASS

## Table of Contents

-   [API](#api)
    -   [SHARNESS_VERSION](#sharness_version)
    -   [SHARNESS_ORIG_TERM](#sharness_orig_term)
    -   [setPrerequisite()](#setprerequisite)
    -   [havePrerequisite()](#haveprerequisite)
    -   [debug()](#debug)
    -   [pause()](#pause)
    -   [expectSuccess()](#expectsucess)
    -   [expectFailure()](#expectfailure)
    -   [mustFail()](#mustfail)
    -   [mightFail()](#mightfail)
    -   [expectCode()](#expectcode)
    -   [compare()](#compare)
    -   [mustBeEmpty()](#mustbeempty)
    -   [whenFinished()](#whenfinished)
    -   [cleanup](#cleanup)
    -   [finish()](#finish)
    -   [SHARNESS_TEST_FILE](#sharness_test_file)
    -   [SHARNESS_TRASH_DIRECTORY](#sharness_trash_directory)
-   [Thanks](#thanks)
-   [License](#license)

## API

### `SHARNESS_VERSION`

Public: Current version of Sharness.

### `SHARNESS_ORIG_TERM`

Public: The unsanitized TERM under which sharness is originally run

### `setPrerequisite()`

Public: Define that a test prerequisite is available.

The prerequisite can later be checked explicitly using havePrerequisite or implicitly by specifying the prerequisite name in calls to expectSuccess or expectFailure.

-   $1 - Name of prerequiste (a simple word, in all capital letters by convention)

Examples

    # Set PYTHON prerequisite if interpreter is available.
    command -v python >/dev/null && setPrerequisite PYTHON

    # Set prerequisite depending on some variable.
    test -z "$NO_GETTEXT" && setPrerequisite GETTEXT

Returns nothing.

### `havePrerequisite()`

Public: Check if one or more test prerequisites are defined.

The prerequisites must have previously been set with setPrerequisite. The most common use of this is to skip all the tests if some essential prerequisite is missing.

-   $1 - Comma-separated list of test prerequisites.

Examples

    # Skip all remaining tests if prerequisite is not set.
    if ! havePrerequisite PERL; then
        skipAll='skipping perl interface tests, perl not available'
        done
    fi

Returns 0 if all prerequisites are defined or 1 otherwise.

### `debug()`

Public: Execute commands in debug mode.

Takes a single argument and evaluates it only when the test script is started with —debug. This is primarily meant for use during the development of test scripts.

-   $1 - Commands to be executed.

Examples

    debug "cat some_log_file"

Returns the exit code of the last command executed in debug mode or 0 otherwise.

### `pause()`

Public: Stop execution and start a shell.

This is useful for debugging tests and only makes sense together with “-v”. Be sure to remove all invocations of this command before submitting.

### `expectSuccess()`

Public: Run test commands and expect them to succeed.

When the test passed, an “ok” message is printed and the number of successful tests is incremented. When it failed, a “not ok” message is printed and the number of failed tests is incremented.

With —immediate, exit test immediately upon the first failed test.

Usually takes two arguments:

-   $1 - Test description
-   $2 - Commands to be executed.

With three arguments, the first will be taken to be a prerequisite:

-   $1 - Comma-separated list of test prerequisites. The test will be skipped if not all of the given prerequisites are set. To negate a prerequisite, put a “!” in front of it.
-   $2 - Test description
-   $3 - Commands to be executed.

Examples

    expectSuccess \
        'git-write-tree should be able to write an empty tree.' \
        'tree=$(git-write-tree)'

    # Test depending on one prerequisite.
    expectSuccess TTY 'git --paginate rev-list uses a pager' \
        ' ... '

    # Multiple prerequisites are separated by a comma.
    expectSuccess PERL,PYTHON 'yo dawg' \
        ' test $(perl -E 'print eval "1 +" . qx[python -c "print 2"]') == "4" '

Returns nothing.

### `expectFailure()`

Public: Run test commands and expect them to fail. Used to demonstrate a known breakage.

This is NOT the opposite of expectSuccess, but rather used to mark a test that demonstrates a known breakage.

When the test passed, an “ok” message is printed and the number of fixed tests is incremented. When it failed, a “not ok” message is printed and the number of tests still broken is incremented.

Failures from these tests won’t cause —immediate to stop.

Usually takes two arguments:

-   $1 - Test description
-   $2 - Commands to be executed.

With three arguments, the first will be taken to be a prerequisite:

-   $1 - Comma-separated list of test prerequisites. The test will be skipped if not all of the given prerequisites are set. To negate a prerequisite, put a “!” in front of it.
-   $2 - Test description
-   $3 - Commands to be executed.

Returns nothing.

### `mustFail()`

Public: Run command and ensure that it fails in a controlled way.

Use it instead of "! <command>". For example, when <command> dies due to a segfault, mustFail diagnoses it as an error, while "! <command>" would mistakenly be treated as just another expected failure.

This is one of the prefix functions to be used inside expectSuccess or expectFailure.

-   $1.. - Command to be executed.

Examples

    expectSuccess 'complain and die' '
        do something &&
        do something else &&
        mustFail git checkout ../outerspace
    '

Returns 1 if the command succeeded (exit code 0). Returns 1 if the command died by signal (exit codes 130–192) Returns 1 if the command could not be found (exit code 127). Returns 0 otherwise.

### `mightFail()`

Public: Run command and ensure that it succeeds or fails in a controlled way.

Similar to mustFail, but tolerates success too. Use it instead of "<command> || :" to catch failures caused by a segfault, for instance.

This is one of the prefix functions to be used inside expectSuccess or expectFailure.

-   $1.. - Command to be executed.

Examples

    expectSuccess 'some command works without configuration' '
        mightFail git config --unset all.configuration &&
        do something
    '

Returns 1 if the command died by signal (exit codes 130–192) Returns 1 if the command could not be found (exit code 127). Returns 0 otherwise.

### `expectCode()`

Public: Run command and ensure it exits with a given exit code.

This is one of the prefix functions to be used inside expectSuccess or expectFailure.

-   $1 - Expected exit code.
-   $2.. - Command to be executed.

Examples

    expectSuccess 'Merge with d/f conflicts' '
        expectCode 1 git merge "merge msg" B master
    '

Returns 0 if the expected exit code is returned or 1 otherwise.

### `compare()`

Public: Compare two files to see if expected output matches actual output.

The TEST_CMP variable defines the command used for the comparision; it defaults to “diff -u”. Only when the test script was started with —verbose, will the command’s output, the diff, be printed to the standard output.

This is one of the prefix functions to be used inside expectSuccess or expectFailure.

-   $1 - Path to file with expected output.
-   $2 - Path to file with actual output.

Examples

    expectSuccess 'foo works' '
        echo expected >expected &&
        foo >actual &&
        compare expected actual
    '

Returns the exit code of the command set by TEST_CMP.

### `mustBeEmpty()`

Public: Check if the file expected to be empty is indeed empty, and barfs otherwise.

-   $1 - File to check for emptyness.

Returns 0 if file is empty, 1 otherwise.

### `whenFinished()`

Public: Schedule cleanup commands to be run unconditionally at the end of a test.

If some cleanup command fails, the test will not pass. With —immediate, no cleanup is done to help diagnose what went wrong.

This is one of the prefix functions to be used inside expectSuccess or expectFailure.

-   $1.. - Commands to prepend to the list of cleanup commands.

Examples

    expectSuccess 'test core.capslock' '
        git config core.capslock true &&
        whenFinished "git config --unset core.capslock" &&
        do_something
    '

Returns the exit code of the last cleanup command executed.

### `cleanup`

Public: Schedule cleanup commands to be run unconditionally when all tests have run.

This can be used to clean up things like test databases. It is not needed to clean up temporary files, as done already does that.

Examples:

    cleanup mysql -e "DROP DATABASE mytest"

Returns the exit code of the last cleanup command executed.

### `finish()`

Public: Summarize test results and exit with an appropriate error code.

Must be called at the end of each test script.

Can also be used to stop tests early and skip all remaining tests. For this, set skipAll to a string explaining why the tests were skipped before calling finish.

Examples

    # Each test script must call done at the end.
    done

    # Skip all remaining tests if prerequisite is not set.
    if ! havePrerequisite PERL; then
        skipAll='skipping perl interface tests, perl not available'
        done
    fi

Returns 0 if all tests passed or 1 if there was a failure.

### `SHARNESS_TEST_FILE`

Public: Path to test script currently executed.

### `SHARNESS_TRASH_DIRECTORY`

Public: Empty trash directory, the test area, provided for each test. The HOME variable is set to that directory too.

## Thanks

Sharness was derived from the [Git] project and maintained until June 2016 by [Mathias
Lafeldt][twitter]. The library is derived from the [Git] project's test-lib.sh.
It is currently maintained by [Christian Couder][chriscool]. See [Github’s
“contributors” page][contributors] for a list of developers. A complete list of
authors should include Git contributors to test-lib.sh too.

## License

sharness is licensed under the terms of the GNU General Public License version
2 or higher. See file [LICENSE] for full license text.

[chriscool]: https://github.com/chriscool

[contributors]: https://github.com/escapace/sharness/graphs/contributors

[license]: https://github.com/escapace/sharness/blob/master/LICENSE

[git]: http://git-scm.com/

[prove(1)]: http://linux.die.net/man/1/prove

[test anything protocol]: http://testanything.org/

[twitter]: https://twitter.com/mlafeldt
