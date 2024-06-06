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

* Try to introduce a pattern like "runTests.sh -s custom:someScriptKey:someScriptParameter".
  Then the "-s" evaluation can specifically act on the "custom:" key and
  separate parameters. Parameter evaluation on Bash is hard, so something
  like "runTests.sh -s custom customAction -customParameter1" is both
  hard to implement and hard to read.
