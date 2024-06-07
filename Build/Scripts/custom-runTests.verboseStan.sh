#!/usr/bin/env bash

#
# Custom script additions
#
# See custom-runTests.sh
#
# This is an example implementation for a custom command:
#
# $ runTests.sh -s custom -- stanVerbose --param1 -param2 -param3
#
# All existing variables from runTests.sh can be utilized.
# Parse ${CUSTOM_COMMAND_ARGUMENTS} for extra arguments.

if [[ -z "$RUNTESTS_DIR_ROOT" ]]; then
  echo "This helper script cannot be run directly, see 'runTests.sh -h'"
  exit 1
fi

echo "(CUSTOM) phpStan verbose [ ${CUSTOM_COMMAND_ARGUMENTS} ]"

COMMAND=(php -dxdebug.mode=off ${RUNTESTS_DIR_BIN}phpstan analyse -c ${PHPSTAN_CONFIG_FILE} -v --no-interaction --memory-limit 4G "$@")
${CONTAINER_BIN} run ${CONTAINER_COMMON_PARAMS} --name phpstan-${SUFFIX} ${IMAGE_PHP} "${COMMAND[@]}"
export SUITE_EXIT_CODE=$?

if [[ $SUITE_EXIT_CODE ]]; then
  return $SUITE_EXIT_CODE
fi

