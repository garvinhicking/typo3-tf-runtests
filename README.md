# typo3-tf-runtests

DRY Experimental base for using runTests.sh in extensions/projects/core

TL;DR: See section "Use of the new runTests.sh in a Composer-based TYPO3 project"

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
  TYPO3 monorepo, so it cannot be included as a require-dev dependency.
* This means, any bugfix or any new feature (adding the latest and greatest
  docker engine) would mean you would have to update the script manually.

This repository acts as a playground to evaluate how `runTests.sh` could
be modified to:

* Be provided as a composer package (maintained in typo3/typo3 core,
  offered as a subtree split repo)
* Be a drop-in replacement for the TYPO3 core, supporting all of its
  current functionality without a change. This means it will need to
  "live" within the monorepos "Build/Scripts/" directory.
* Allow customization through dispatching of self-maintained extending
  scripts and "understanding" parameters
* Provide a "setup" helper that copies typo3/testing-framework template
  files with adapted paths to the wanted places (TODO)

# Central motivation / goals

* "Don't Repeat Yourself" and try to prevent "Not Invented Here" syndrome:
  We all want testing just to work, and work great, and without the need
  to copy+paste things and by this taking over maintaining those scripts.
* "Convention over Configuration": runTests.sh is kind of opinionated,
  it does not want to support every need there is, but provide a common
  ground. Everything that needs customization should be done with
  self-maintained ADDITIONAL scripts. This is a good thing.
* Change the current runTests.sh as little as possible
* This is NOT meant as "EVERYTHING needs to be customized", it shall not
  become unmaintainable with flexibility, but instead be maintainable
  through better flexibility and outside usage feedback.

# Experimental

**ALL OF THIS IS EXPERIMENTAL**

Use at your own care/risk.

There are two use cases:

## Use of the new runTests.sh in TYPO3 core (monorepo)

The setup would be that this repository will cease to exist.

The files from Build/Scripts/ would all be moved to the `typo3/typo3` repository.

From there, a subtree split would create a package like `typo3/runtests`,
containing the files of `Build/Scripts`.

That means inside `Build/Scripts` a `composer.json` file would need
to be created to contain that metadata. A `bin` configuration there
would be needed, and probably `require-dev` dependencies.

To simulate this you can:

* Take a `typo3/typo3` GIT clone (`main`)
* Copy the files from `Build/Scripts/` of this repository into the same directory of the monorepo
* **REMOVE** `Build/Scripts/runTests.env`! For the core, the settings are contained inside `runTests.sh`.
* Execute `Build/Scripts/runTests.sh` like before. Nothing should change. If something changes, it's a bug and not intended. 

## Use of the new runTests.sh in a Composer-based TYPO3 project

For this I've created a separate project, so you can:

* `git clone https://github.com/garvinhicking/tf-basics-project`
* `cd tf-basics-project`
* `git checkout runtests` (**important**)
* `composer install`
* `./vendor/bin/runTests.sh -s unit`
* `./vendor/bin/runTests.sh -s custom -- myStan`

This project comes with a predefined configuration `runTests.env` that is used, and some
stub tests and config files.

There might even be a generator for such a `runTests.env` file, but that is beyond scope for now.

Just check out this repository, you should be able to adapt that
with any custom extension or project, you need:

* A `composer.json` requiring TYPO3 (duh) and require-dev this `garvinhicking/typo3-tf-runtests` repository (for now; in the future a `typo3/runtests` package hopefully)
* The mentioned `runTests.env` file
* Configuration files for `phpunit`, `phpstan` and whatever else you plan to utilize
* Any kind of custom `custom-runTests.xxx.sh` dispatchees
* PHP files / extension files you want to test
* Maybe some `.ddev` configuration, but `runTests` is fully functional without `ddev`.

# CAVEATS

* There are A LOT of variables that need assignment
* The initial required pull of "runTests.sh" makes it impossible to use the provided `runTests.sh`
  file to use that for a `composer install`. Only after composer has initially fetched it, you could
  use `vendor/bin/runTests.sh -s composerInstall` to use the dockerized setup. Classical chicken/egg.
  For the TYPO3 mono-repo instance this is not an issue, because `runTests.sh` "lives" there and
  does not require composer to actually fetch it.

# Feedback

Yes. Please. Inspire people to share.
