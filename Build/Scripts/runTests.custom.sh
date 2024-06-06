#!/usr/bin/env bash

#
# Custom script additions
#
# The basic 'runTests.sh' is not meant to do everything for everyone.
#
# To implement your custom tools based on the basis of runTests.sh,
# these custom sub-scripts can act as little helpers, where you can
# access all the variables from the main script.

if [[ -z "$RUNTESTS_DIR_ROOT" ]]; then
  echo "This helper script cannot be run directly, see 'runTests.sh -h'"
  exit 1
fi

# @TODO
# Create example how to evaluate extra parameters and execute CONTAINER_BIN etc.
# Maybe something like "-s custom -- psalm"

# @TODO
# - Check for the first parameter (for example "myLint")
# - Check if such a .sh file exists
# - If no, bail out with error
# - If yes, call that script too (runTests.myLint.sh)

