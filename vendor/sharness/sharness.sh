#!/usr/bin/env bash
# shellcheck disable=SC2034
#
# Copyright (c) 2011-2012 Mathias Lafeldt
# Copyright (c) 2005-2012 Git project
# Copyright (c) 2005-2012 Junio C Hamano
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/ .

# Public: Current version of Sharness.
SHARNESS_VERSION="1.0.0"
export SHARNESS_VERSION

# Public: The file extension for tests.  By default, it is set to "t".
: "${SHARNESS_TEST_EXTENSION:=t}"
export SHARNESS_TEST_EXTENSION

#  Reset TERM to original terminal if found, otherwise save orignal TERM
[ "x" = "x$SHARNESS_ORIG_TERM" ] &&
		SHARNESS_ORIG_TERM="$TERM" ||
		TERM="$SHARNESS_ORIG_TERM"
# Public: The unsanitized TERM under which sharness is originally run
export SHARNESS_ORIG_TERM

# Export SHELL_PATH
: "${SHELL_PATH:=$SHELL}"
export SHELL_PATH

# For repeatability, reset the environment to a known state.
# TERM is sanitized below, after saving color control sequences.
LANG=C
LC_ALL=C
PAGER=cat
TZ=UTC
EDITOR=:
export LANG LC_ALL PAGER TZ EDITOR
unset VISUAL CDPATH GREP_OPTIONS

# Line feed
LF='
'

[ "x$TERM" != "xdumb" ] && (
		[ -t 1 ] &&
		tput bold >/dev/null 2>&1 &&
		tput setaf 1 >/dev/null 2>&1 &&
		tput sgr0 >/dev/null 2>&1
	) &&
	color=t

while test "$#" -ne 0; do
	case "$1" in
	-d|--d|--de|--deb|--debu|--debug)
		debug=t; shift ;;
	-i|--i|--im|--imm|--imme|--immed|--immedi|--immedia|--immediat|--immediate)
		immediate=t; shift ;;
	-l|--l|--lo|--lon|--long|--long-|--long-t|--long-te|--long-tes|--long-test|--long-tests)
		TEST_LONG=t; export TEST_LONG; shift ;;
	--in|--int|--inte|--inter|--intera|--interac|--interact|--interacti|--interactiv|--interactive|--interactive-|--interactive-t|--interactive-te|--interactive-tes|--interactive-test|--interactive-tests):
		TEST_INTERACTIVE=t; export TEST_INTERACTIVE; verbose=t; shift ;;
	-h|--h|--he|--hel|--help)
		help=t; shift ;;
	-v|--v|--ve|--ver|--verb|--verbo|--verbos|--verbose)
		verbose=t; shift ;;
	-q|--q|--qu|--qui|--quie|--quiet)
		# Ignore --quiet under a TAP::Harness. Saying how many tests
		# passed without the ok/not ok details is always an error.
		test -z "$HARNESS_ACTIVE" && quiet=t; shift ;;
	--chain-lint)
		chain_lint=t; shift ;;
	--no-chain-lint)
		chain_lint=; shift ;;
	--no-color)
		color=; shift ;;
	--root=*)
		root=$(expr "z$1" : 'z[^=]*=\(.*\)')
		shift ;;
	*)
		echo "error: unknown test option '$1'" >&2; exit 1 ;;
	esac
done

if test -n "$color"; then
	# Save the color control sequences now rather than run tput
	# each time say_color() is called.  This is done for two
	# reasons:
	#   * TERM will be changed to dumb
	#   * HOME will be changed to a temporary directory and tput
	#     might need to read ~/.terminfo from the original HOME
	#     directory to get the control sequences
	# Note:  This approach assumes the control sequences don't end
	# in a newline for any terminal of interest (command
	# substitutions strip trailing newlines).  Given that most
	# (all?) terminals in common use are related to ECMA-48, this
	# shouldn't be a problem.
	say_color_error=$(tput bold; tput setaf 1) # bold red
	say_color_skip=$(tput setaf 4) # blue
	say_color_warn=$(tput setaf 3) # brown/yellow
	say_color_pass=$(tput setaf 2) # green
	say_color_info=$(tput setaf 6) # cyan
	say_color_reset=$(tput sgr0)
	say_color_="" # no formatting for normal text
	say_color() {
		test -z "$1" && test -n "$quiet" && return
		eval "say_color_color=\$say_color_$1"
		shift
		printf "%s\\n" "$say_color_color$*$say_color_reset"
	}
else
	say_color() {
		test -z "$1" && test -n "$quiet" && return
		shift
		printf "%s\n" "$*"
	}
fi

TERM=dumb
export TERM

error() {
	say_color error "error: $*"
	EXIT_OK=t
	exit 1
}

say() {
	say_color info "$*"
}

test -n "$description" || true

if test "$help" = "t"; then
	echo "Test script did not set description."
	exit 0
fi

exec 5>&1
exec 6<&0
if test "$verbose" = "t"; then
	exec 4>&2 3>&1
else
	exec 4>/dev/null 3>/dev/null
fi

test_failure=0
test_count=0
test_fixed=0
test_broken=0
test_success=0

die() {
	code=$?
	if test -n "$EXIT_OK"; then
		exit $code
	else
		echo >&5 "FATAL: Unexpected exit with code $code"
		exit 1
	fi
}

EXIT_OK=
trap 'die' EXIT

# Public: Define that a test prerequisite is available.
#
# The prerequisite can later be checked explicitly using havePrerequisite or
# implicitly by specifying the prerequisite name in calls to expectSuccess
# or expectFailure.
#
# $1 - Name of prerequiste (a simple word, in all capital letters by convention)
#
# Examples
#
#   # Set PYTHON prerequisite if interpreter is available.
#   command -v python >/dev/null && setPrerequisite PYTHON
#
#   # Set prerequisite depending on some variable.
#   test -z "$NO_GETTEXT" && setPrerequisite GETTEXT
#
# Returns nothing.
setPrerequisite() {
	satisfied_prereq="$satisfied_prereq$1 "
}
satisfied_prereq=" "

# Public: Check if one or more test prerequisites are defined.
#
# The prerequisites must have previously been set with setPrerequisite.
# The most common use of this is to skip all the tests if some essential
# prerequisite is missing.
#
# $1 - Comma-separated list of test prerequisites.
#
# Examples
#
#   # Skip all remaining tests if prerequisite is not set.
#   if ! havePrerequisite PERL; then
#       skipAll='skipping perl interface tests, perl not available'
#       done
#   fi
#
# Returns 0 if all prerequisites are defined or 1 otherwise.
havePrerequisite() {
	# prerequisites can be concatenated with ','
	save_IFS=$IFS
	IFS=,
	set -- $*
	IFS=$save_IFS

	total_prereq=0
	ok_prereq=0
	missing_prereq=

	for prerequisite; do
		case "$prerequisite" in
		!*)
			negative_prereq=t
			prerequisite=${prerequisite#!}
			;;
		*)
			negative_prereq=
		esac

		total_prereq=$((total_prereq + 1))
		case "$satisfied_prereq" in
		*" $prerequisite "*)
			satisfied_this_prereq=t
			;;
		*)
			satisfied_this_prereq=
		esac

		case "$satisfied_this_prereq,$negative_prereq" in
		t,|,t)
			ok_prereq=$((ok_prereq + 1))
			;;
		*)
			# Keep a list of missing prerequisites; restore
			# the negative marker if necessary.
			prerequisite=${negative_prereq:+!}$prerequisite
			if test -z "$missing_prereq"; then
				missing_prereq=$prerequisite
			else
				missing_prereq="$prerequisite,$missing_prereq"
			fi
		esac
	done

	test $total_prereq = $ok_prereq
}

# You are not expected to call test_ok_ and test_failure_ directly, use
# the text_expect_* functions instead.

test_ok_() {
	test_success=$((test_success + 1))
	say_color "" "ok $test_count - $@"
}

test_failure_() {
	test_failure=$((test_failure + 1))
	say_color error "not ok $test_count - $1"
	shift
	echo "$@" | sed -e 's/^/#	/'
	test "$immediate" = "" || { EXIT_OK=t; exit 1; }
}

test_known_broken_ok_() {
	test_fixed=$((test_fixed + 1))
	say_color error "ok $test_count - $@ # TODO known breakage vanished"
}

test_known_broken_failure_() {
	test_broken=$((test_broken + 1))
	say_color warn "not ok $test_count - $@ # TODO known breakage"
}

# Public: Execute commands in debug mode.
#
# Takes a single argument and evaluates it only when the test script is started
# with --debug. This is primarily meant for use during the development of test
# scripts.
#
# $1 - Commands to be executed.
#
# Examples
#
#   debug "cat some_log_file"
#
# Returns the exit code of the last command executed in debug mode or 0
#   otherwise.
debug() {
	test "$debug" = "" || eval "$1"
}

# Public: Stop execution and start a shell.
#
# This is useful for debugging tests and only makes sense together with "-v".
# Be sure to remove all invocations of this command before submitting.
pause() {
	if test "$verbose" = t; then
		"$SHELL_PATH" <&6 >&3 2>&4
	else
		error >&5 "pause requires --verbose"
	fi
}

test_eval_() {
	# This is a separate function because some tests use
	# "return" to end a expectSuccess block early.
	case ",$test_prereq," in
	*,INTERACTIVE,*)
		eval "$*"
		;;
	*)
		eval </dev/null >&3 2>&4 "$*"
		;;
	esac
}

test_run_() {
	test_cleanup=:
	expecting_failure=$2
	test_eval_ "$1"
	eval_ret=$?

	if test "$chain_lint" = "t"; then
		test_eval_ "(exit 117) && $1"
		if test "$?" != 117; then
			error "bug in the test script: broken &&-chain: $1"
		fi
	fi

	if test -z "$immediate" || test $eval_ret = 0 || test -n "$expecting_failure"; then
		test_eval_ "$test_cleanup"
	fi
	if test "$verbose" = "t" && test -n "$HARNESS_ACTIVE"; then
		echo ""
	fi
	return "$eval_ret"
}

test_skip_() {
	test_count=$((test_count + 1))
	to_skip=
	for skp in $SKIP_TESTS; do
		case $this_test.$test_count in
		$skp)
			to_skip=t
			break
		esac
	done
	if test -z "$to_skip" && test -n "$test_prereq" && ! havePrerequisite "$test_prereq"; then
		to_skip=t
	fi
	case "$to_skip" in
	t)
		of_prereq=
		if test "$missing_prereq" != "$test_prereq"; then
			of_prereq=" of $test_prereq"
		fi

		say_color skip >&3 "skipping test: $@"
		say_color skip "ok $test_count # skip $1 (missing $missing_prereq${of_prereq})"
		: true
		;;
	*)
		false
		;;
	esac
}

# Public: Run test commands and expect them to succeed.
#
# When the test passed, an "ok" message is printed and the number of successful
# tests is incremented. When it failed, a "not ok" message is printed and the
# number of failed tests is incremented.
#
# With --immediate, exit test immediately upon the first failed test.
#
# Usually takes two arguments:
# $1 - Test description
# $2 - Commands to be executed.
#
# With three arguments, the first will be taken to be a prerequisite:
# $1 - Comma-separated list of test prerequisites. The test will be skipped if
#      not all of the given prerequisites are set. To negate a prerequisite,
#      put a "!" in front of it.
# $2 - Test description
# $3 - Commands to be executed.
#
# Examples
#
#   expectSuccess \
#       'git-write-tree should be able to write an empty tree.' \
#       'tree=$(git-write-tree)'
#
#   # Test depending on one prerequisite.
#   expectSuccess TTY 'git --paginate rev-list uses a pager' \
#       ' ... '
#
#   # Multiple prerequisites are separated by a comma.
#   expectSuccess PERL,PYTHON 'yo dawg' \
#       ' test $(perl -E 'print eval "1 +" . qx[python -c "print 2"]') == "4" '
#
# Returns nothing.
expectSuccess() {
	test "$#" = 3 && { test_prereq=$1; shift; } || test_prereq=
	test "$#" = 2 || error "bug in the test script: not 2 or 3 parameters to expectSuccess"
	export test_prereq
	if ! test_skip_ "$@"; then
		say >&3 "expecting success: $2"
		if test_run_ "$2"; then
			test_ok_ "$1"
		else
			test_failure_ "$@"
		fi
	fi
	echo >&3 ""
}

# Public: Run test commands and expect them to fail. Used to demonstrate a known
# breakage.
#
# This is NOT the opposite of expectSuccess, but rather used to mark a
# test that demonstrates a known breakage.
#
# When the test passed, an "ok" message is printed and the number of fixed tests
# is incremented. When it failed, a "not ok" message is printed and the number
# of tests still broken is incremented.
#
# Failures from these tests won't cause --immediate to stop.
#
# Usually takes two arguments:
# $1 - Test description
# $2 - Commands to be executed.
#
# With three arguments, the first will be taken to be a prerequisite:
# $1 - Comma-separated list of test prerequisites. The test will be skipped if
#      not all of the given prerequisites are set. To negate a prerequisite,
#      put a "!" in front of it.
# $2 - Test description
# $3 - Commands to be executed.
#
# Returns nothing.
expectFailure() {
	test "$#" = 3 && { test_prereq=$1; shift; } || test_prereq=
	test "$#" = 2 || error "bug in the test script: not 2 or 3 parameters to expectFailure"
	export test_prereq
	if ! test_skip_ "$@"; then
		say >&3 "checking known breakage: $2"
		if test_run_ "$2" expecting_failure; then
			test_known_broken_ok_ "$1"
		else
			test_known_broken_failure_ "$1"
		fi
	fi
	echo >&3 ""
}

# Public: Run command and ensure that it fails in a controlled way.
#
# Use it instead of "! <command>". For example, when <command> dies due to a
# segfault, mustFail diagnoses it as an error, while "! <command>" would
# mistakenly be treated as just another expected failure.
#
# This is one of the prefix functions to be used inside expectSuccess or
# expectFailure.
#
# $1.. - Command to be executed.
#
# Examples
#
#   expectSuccess 'complain and die' '
#       do something &&
#       do something else &&
#       mustFail git checkout ../outerspace
#   '
#
# Returns 1 if the command succeeded (exit code 0).
# Returns 1 if the command died by signal (exit codes 130-192)
# Returns 1 if the command could not be found (exit code 127).
# Returns 0 otherwise.
mustFail() {
	"$@"
	exit_code=$?
	if test $exit_code = 0; then
		echo >&2 "mustFail: command succeeded: $*"
		return 1
	elif test $exit_code -gt 129 -a $exit_code -le 192; then
		echo >&2 "mustFail: died by signal: $*"
		return 1
	elif test $exit_code = 127; then
		echo >&2 "mustFail: command not found: $*"
		return 1
	fi
	return 0
}

# Public: Run command and ensure that it succeeds or fails in a controlled way.
#
# Similar to mustFail, but tolerates success too. Use it instead of
# "<command> || :" to catch failures caused by a segfault, for instance.
#
# This is one of the prefix functions to be used inside expectSuccess or
# expectFailure.
#
# $1.. - Command to be executed.
#
# Examples
#
#   expectSuccess 'some command works without configuration' '
#       mightFail git config --unset all.configuration &&
#       do something
#   '
#
# Returns 1 if the command died by signal (exit codes 130-192)
# Returns 1 if the command could not be found (exit code 127).
# Returns 0 otherwise.
mightFail() {
	"$@"
	exit_code=$?
	if test $exit_code -gt 129 -a $exit_code -le 192; then
		echo >&2 "mightFail: died by signal: $*"
		return 1
	elif test $exit_code = 127; then
		echo >&2 "mightFail: command not found: $*"
		return 1
	fi
	return 0
}

# Public: Run command and ensure it exits with a given exit code.
#
# This is one of the prefix functions to be used inside expectSuccess or
# expectFailure.
#
# $1   - Expected exit code.
# $2.. - Command to be executed.
#
# Examples
#
#   expectSuccess 'Merge with d/f conflicts' '
#       expectCode 1 git merge "merge msg" B master
#   '
#
# Returns 0 if the expected exit code is returned or 1 otherwise.
expectCode() {
	want_code=$1
	shift
	"$@"
	exit_code=$?
	if test "$exit_code" = "$want_code"; then
		return 0
	fi

	echo >&2 "expectCode: command exited with $exit_code, we wanted $want_code $*"
	return 1
}

# Public: Compare two files to see if expected output matches actual output.
#
# The TEST_CMP variable defines the command used for the comparision; it
# defaults to "diff -u". Only when the test script was started with --verbose,
# will the command's output, the diff, be printed to the standard output.
#
# This is one of the prefix functions to be used inside expectSuccess or
# expectFailure.
#
# $1 - Path to file with expected output.
# $2 - Path to file with actual output.
#
# Examples
#
#   expectSuccess 'foo works' '
#       echo expected >expected &&
#       foo >actual &&
#       compare expected actual
#   '
#
# Returns the exit code of the command set by TEST_CMP.
compare() {
	${TEST_CMP:-diff -u} "$@"
}

# Public: portably print a sequence of numbers.
#
# seq is not in POSIX and GNU seq might not be available everywhere,
# so it is nice to have a seq implementation, even a very simple one.
#
# $1 - Starting number.
# $2 - Ending number.
#
# Examples
#
#   expectSuccess 'foo works 10 times' '
#       for i in $(sequence 1 10)
#       do
#           foo || return
#       finish
#   '
#
# Returns 0 if all the specified numbers can be displayed.
# sequence() {
# 	i="$1"
# 	j="$2"
# 	while test "$i" -le "$j"
# 	do
# 		echo "$i" || return
# 		# i=$(expr "$i" + 1)
# 		i=$((i+1))
# 	done
# }

# Public: Check if the file expected to be empty is indeed empty, and barfs
# otherwise.
#
# $1 - File to check for emptyness.
#
# Returns 0 if file is empty, 1 otherwise.
mustBeEmpty() {
	if test -s "$1"
	then
		echo "'$1' is not empty, it contains:"
		cat "$1"
		return 1
	fi
}

# Public: Schedule cleanup commands to be run unconditionally at the end of a
# test.
#
# If some cleanup command fails, the test will not pass. With --immediate, no
# cleanup is done to help diagnose what went wrong.
#
# This is one of the prefix functions to be used inside expectSuccess or
# expectFailure.
#
# $1.. - Commands to prepend to the list of cleanup commands.
#
# Examples
#
#   expectSuccess 'test core.capslock' '
#       git config core.capslock true &&
#       whenFinished "git config --unset core.capslock" &&
#       do_something
#   '
#
# Returns the exit code of the last cleanup command executed.
whenFinished() {
	test_cleanup="{ $*
		} && (exit \"\$eval_ret\"); eval_ret=\$?; $test_cleanup"
}

# Public: Schedule cleanup commands to be run unconditionally when all tests
# have run.
#
# This can be used to clean up things like test databases. It is not needed to
# clean up temporary files, as done already does that.
#
# Examples:
#
#   cleanup mysql -e "DROP DATABASE mytest"
#
# Returns the exit code of the last cleanup command executed.
cleanup=
cleanup() {
	cleanup="{ $*
		} && (exit \"\$eval_ret\"); eval_ret=\$?; $cleanup"
}

# Public: Summarize test results and exit with an appropriate error code.
#
# Must be called at the end of each test script.
#
# Can also be used to stop tests early and skip all remaining tests. For this,
# set skipAll to a string explaining why the tests were skipped before calling
# finish.
#
# Examples
#
#   # Each test script must call done at the end.
#   done
#
#   # Skip all remaining tests if prerequisite is not set.
#   if ! havePrerequisite PERL; then
#       skipAll='skipping perl interface tests, perl not available'
#       done
#   fi
#
# Returns 0 if all tests passed or 1 if there was a failure.
finish() {
	EXIT_OK=t

	if test -z "$HARNESS_ACTIVE"; then

		if [ ! -z "${SHARNESS_RESULT}" ]
		then
			test_results_path="$SHARNESS_RESULT"
		else
			test_results_dir="$SHARNESS_TEST_DIRECTORY/test-results"
			mkdir -p "$test_results_dir"
			test_results_path="$test_results_dir/$this_test.$$.counts"
		fi

		cat >>"$test_results_path" <<-EOF
		total $test_count
		success $test_success
		fixed $test_fixed
		broken $test_broken
		failed $test_failure

		EOF
	fi

	if test "$test_fixed" != 0; then
		say_color error "# $test_fixed known breakage(s) vanished; please update test(s)"
	fi
	if test "$test_broken" != 0; then
		say_color warn "# still have $test_broken known breakage(s)"
	fi
	if test "$test_broken" != 0 || test "$test_fixed" != 0; then
		test_remaining=$(( test_count - test_broken - test_fixed ))
		msg="remaining $test_remaining test(s)"
	else
		test_remaining=$test_count
		msg="$test_count test(s)"
	fi

	case "$test_failure" in
	0)
		# Maybe print SKIP message
		if test -n "$skipAll" && test $test_count -gt 0; then
			error "Can't use skipAll after running some tests"
		fi
		[ -z "$skipAll" ] || skipAll=" # SKIP $skipAll"

		if test $test_remaining -gt 0; then
			say_color pass "# passed all $msg"
		fi
		say "1..$test_count$skipAll"

		test_eval_ "$cleanup"

		test -d "$remove_trash" &&
		cd "$(dirname "$remove_trash")" &&
		rm -rf "$(basename "$remove_trash")"

		exit 0 ;;

	*)
		say_color error "# failed $test_failure among $msg"
		say "1..$test_count"

		exit 1 ;;

	esac
}

# Public: Root directory containing tests. Tests can override this variable,
# e.g. for testing Sharness itself.
: "${SHARNESS_TEST_DIRECTORY:=$(pwd)}"
export SHARNESS_TEST_DIRECTORY

# Public: Source directory of test code and sharness library.
# This directory may be different from the directory in which tests are
# being run.
: "${SHARNESS_TEST_SRCDIR:="$(cd "$(dirname "$0")" && pwd)"}"
export SHARNESS_TEST_SRCDIR

# Public: Build directory that will be added to PATH. By default, it is set to
# the parent directory of SHARNESS_TEST_DIRECTORY.
: "${SHARNESS_BUILD_DIRECTORY:="$SHARNESS_TEST_DIRECTORY/.."}"
PATH="$SHARNESS_BUILD_DIRECTORY:$PATH"
export PATH SHARNESS_BUILD_DIRECTORY

# Public: Path to test script currently executed.
SHARNESS_TEST_FILE="$0"
export SHARNESS_TEST_FILE

# Prepare test area.
if [[ -z "${SHARNESS_TRASH_DIRECTORY}" ]]
then
	SHARNESS_TRASH_DIRECTORY="trash directory.$(basename "$SHARNESS_TEST_FILE" ".$SHARNESS_TEST_EXTENSION")"
	test -n "$root" && SHARNESS_TRASH_DIRECTORY="$root/$SHARNESS_TRASH_DIRECTORY"

	case "$SHARNESS_TRASH_DIRECTORY" in
		/*) ;; # absolute path is good
		 *) SHARNESS_TRASH_DIRECTORY="$SHARNESS_TEST_DIRECTORY/$SHARNESS_TRASH_DIRECTORY" ;;
	esac

	test "$debug" = "t" || remove_trash="$SHARNESS_TRASH_DIRECTORY"

	rm -rf "$SHARNESS_TRASH_DIRECTORY" || {
		EXIT_OK=t
		echo >&5 "FATAL: Cannot prepare test area"
		exit 1
	}
fi

#
#  Load any extensions in $srcdir/sharness.d/*.sh
#
if test -d "${SHARNESS_TEST_SRCDIR}/sharness.d"
then
	for file in "${SHARNESS_TEST_SRCDIR}"/sharness.d/*.sh
	do
		# Ensure glob was not an empty match:
		test -e "${file}" || break

		if test -n "$debug"
		then
			echo >&5 "sharness: loading extensions from ${file}"
		fi
		. "${file}"
		if test $? != 0
		then
			echo >&5 "sharness: Error loading ${file}. Aborting."
			exit 1
		fi
	done
fi

# Public: Empty trash directory, the test area, provided for each test. The HOME
# variable is set to that directory too.
export SHARNESS_TRASH_DIRECTORY

HOME="$SHARNESS_TRASH_DIRECTORY"
export HOME

mkdir -p "$SHARNESS_TRASH_DIRECTORY" || exit 1
# Use -P to resolve symlinks in our working directory so that the cwd
# in subprocesses like git equals our $PWD (for pathname comparisons).
cd -P "$SHARNESS_TRASH_DIRECTORY" || exit 1

this_test=${SHARNESS_TEST_FILE##*/}
this_test=${this_test%.$SHARNESS_TEST_EXTENSION}
for skp in $SKIP_TESTS; do
	case "$this_test" in
	$skp)
		say_color info >&3 "skipping test $this_test altogether"
		skipAll="skip all tests in $this_test"
		finish
	esac
done

test -n "$TEST_LONG" && setPrerequisite EXPENSIVE
test -n "$TEST_INTERACTIVE" && setPrerequisite INTERACTIVE

# Make sure this script ends with code 0
:

# vi: set ts=4 sw=4 noet :
