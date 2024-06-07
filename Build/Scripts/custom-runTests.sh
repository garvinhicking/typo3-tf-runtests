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

BASE_COMMAND=$(echo $COMMAND | cut -d' ' -f1)
CUSTOM_COMMAND_ARGUMENTS=$(echo $COMMAND | cut -d' ' -f2-)
SUB_SCRIPT="${RUNTESTS_DIR_BUILDER}custom-runTests.${BASE_COMMAND}.sh"

if [[ ! -f "$SUB_SCRIPT" ]];
then
  # When using the composer package of runTests, custom tests
  # will be in their own directory outside of this tree.
  SUB_SCRIPT="${RUNTESTS_DIR_CUSTOM}custom-runTests.${BASE_COMMAND}.sh"
fi

if [[ -f "$SUB_SCRIPT" ]];
then
  echo "Dispatching: $SUB_SCRIPT $COMMAND_ARGUMENTS"
  source $SUB_SCRIPT
  return $?
else
  echo "Custom argument $SUB_SCRIPT not found or executable."
  return 1
fi
