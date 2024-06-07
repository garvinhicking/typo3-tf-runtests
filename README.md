# typo3-tf-runtests

DRY Experimental base for using runTests.sh in extensions/projects/core

# What is this?

The TYPO3 core's runTests.sh file
(https://github.com/TYPO3/typo3/blob/main/Build/Scripts/runTests.sh)
is awesome:

* It integrates with the https://github.com/TYPO3/testing-framework which
  provides a basis to perform unit and functional tests with a TYPO3
  framework

* It utilizes docker or podman, giving a choice of container implementation

* It offers easy xdebug integration for test execution

* It allows a wide range of supported PHP and database versions, great for
  CI matrix integration

* Low dependencies: Just docker or podman and bash, available on Windows
  WSL, Linux/Unix and macOS

* The same script with its parameters can be run locally and within CI

* it is actively maintained and utilized by the TYPO3 core

However, it has one large drawback:

* It cannot be used for TYPO3 extensions or TYPO3-based projects without
  being copied to those repositories. runTests.sh is part of the
  TYPO3 monorepo, so it cannot be included as a require-dev dependency

This repository acts as a playground to evaluate how `runTests.sh` could
be modified to:

* Be provided as a composer package (ideally, within the
  typo3/testing-framework!)
* Be a drop-in replacement for the TYPO3 core, supporting all of its
  current functionality without a change. This means it will need to
  "live" within the monorepos "Build/Scripts/" directory (possibly as a
  symlink)
* Allow customization through dispatching of self-maintained extending
  scripts and "understanding" parameters
* Provide a "setup" helper that copies typo3/testing-framework template
  files with adapted paths to the wanted places

# Central motivation / goals

* "Don't Repeat Yourself" and try to prevent "Not Invented Here" syndrome:
  We all want testing just to work, and work great, and without the need
  to copy+paste things and by this taking over maintaining those scripts.
* "Convention over Configuration": runTests.sh is kind of oppinionated,
  it does not want to support every need there is, but provide a common
  ground. Everything that needs customization should be done with
  self-maintained ADDITIONAL scripts.
* Change the current runTests.sh as little as possible
* This is NOT meant as "EVERYTHING needs to be customized"

# How exactly?

(TODO)

* Try to introduce a pattern like "runTests.sh -s custom -- someScriptKey -someScriptParameter".
* Configuration for (seperate file?):
  * Build file locations
  * Cache file locations
  * Test file cache locations
  * Documentation file locations
  * "self" (references to Build/Scripts/runTests.sh)
* "make docs"
* SEPERATE commits for each config type

# Needed files

* typo3/typo3:Build/Scripts/runTests.sh
* some default phpstan etc. configs

# TODO: FUTURE "HOW TO"

## FIRST TIME PROJECT SETUP

The following steps would be performed ONCE and the results committed to your project:

* In your project's composer.json, require-dev the package `garvinhicking/typo3-tf-runtests`
* Be sure your project's composer.json already has a require for typo3/typo3 and a require-dev for `typo3/testing-framework`!
* Let runTests.sh know of your project setup, which saves environment variables in a file "runTests.env" in a chosen directory, for example:
  ```bash
  ./vendor/garvinhicking/typo3-tf-runtests/Build/Scripts/runTests.sh \
    -s custom  \
    -- \
    setup \
      -build-root ".Build" \
      -scripts-root ".Build/Scripts" \
      -vendor-bin "./vendor/bin" \
      -test "Tests/" \ 
      -test "packages/*/Tests"`
  ```
  Note this is an example, you need to adapt the mentioned directories to your project structure!
* This will:
  * execute runTests.sh of this project ...
  * ... that runs a custom sub-script (`-s custom`) (triggering `./vendor/garvinhicking/typo3-tf-runtests/Build/Scripts/runTests.custom.sh`) 
  * ... that will get parameters (`--`)
  * ... which are:
    * ... set the `build-root` where all build-related files are expected to `.Build`. Note that this is specifically chose because TYPO3 core uses "Build", and this repository wants to showcase that the directory can be configured to anything!
    * ... set the `scripts-root` where the "runTests.sh" symlink will be created and where the `runTests.env` file will be created.
    * ... set the `vendor-bin` option to point to where your project's vendor folder is located. The TYPO3 core has a special setup because this is stored in `./bin` where usually for project's this would be `vendor/bin`.
    * ... set two entries for test directory locations
* When the script is run, the following happens:
  * A file `.Build/Scripts/runTests.env` will be created with the configuration values
  * A file `.Build/Scripts/runTests.sh` will be symlinked to `./vendor/garvinhicking/typo3-tf-runtests/Build/Scripts/runtests.sh` to allow easier execution of the script later on (via `./Build/Scripts/runTests.sh`)
  * The template files from `typo3/testing-framework` will be copied to the appropriate directory within `.Build`, containing the adapted paths for the `-test` parameter(s) (you can specify multiple ones)
* IMPORTANT: After that you should commit the following files to your project:
  * `.Build/Scripts/runTests.sh` (a symlink!)
  * `.Build/Scripts/runTests.env` (the configuration for your project)
  * `composer.json` and `composer.lock` (because of the dependencies you just added)
* Now you can use the `runTests.sh` script and its arguments like usual

## EXISTING PROJECT

The previous step created the `runTests.sh` symlink as well as the `runTests.env` configuration.

Just clone the repository, perform and use `runTests.sh` and you're done.

CAVEAT:

Now I see the main problem. "runTests.sh" would be a composer package, and you would locally
need to execute composer to require/install it, then you cannot use the monorepo direct
access to "runTests.sh" to run a dockerized composer installation.

To remedy this maybe something like this could work:

* Actually make "runTests.sh" part of typo3/typo3 and do a repo-split on "Build/Scripts"
* Then runTests.sh is maintained in typo3/typo3 and a distinct package of "Build/Scripts" is available
* Foreign projects can use that one, typo3 can just continue to use its own fixed binary

