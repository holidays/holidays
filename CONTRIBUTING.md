# How to contribute

There are multiple ways to help! We rely on users around the world to help keep our definitions accurate and up to date. In addition, pull requests to address bugs or implement new features are always welcome.

## Code of Conduct

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing. Everyone interacting with this project (or associated projects) is expected to abide by its terms.

## General note

The definitions for this project are housed in a submodule. Please make sure to run `git clone --recursive git@github.com/holidays/holidays`
or, if you forgot to do so, run `make update-defs` so that all of the submodule data is pulled down.

## For definition updates

Our definitions are written in YAML. They are housed in a [separate repository](https://github.com/holidays/definitions) so that they can be used by tools written in other languages. You can find a complete guide to our format in the [definitions SYNTAX guide](https://github.com/holidays/definitions/blob/master/SYNTAX.md).

In this ruby project we take the YAML definitions and generate final ruby classes that are loaded at runtime for fast calculations.

Once you have a good idea on what you want to change, please see the [contributing guide](https://github.com/holidays/definitions/blob/master/CONTRIBUTING.md) in the `definitions` repository.

The idea is that if the validation passes on the other repo then you shouldn't have to worry about generating and testing here. We'll see how that goes!

Once that PR is accepted the maintainers of this project will be responsible for generating the updated definitions and releasing a new gem. Don't worry about versioning, we'll take care of it!

## For non-definition functionality

* Fork this repository
* Make your changes
* Create a PR pointing back to `master`

Don't worry about versioning, we'll handle it on our end.

*Tests are required*. If your PR results in lower test coverage then it will not be accepted.

## Local development helpers

We have included a few handy tasks to help you troubleshoot and test:

* `make test` - runs the entire suite
* `REGION=<region> make test-region` - runs the tests for just that region
* `make console` - launches an IRB session with the 'holidays' gem loaded for quick testing
* `make update-defs` - this will run the appropriate git submodule commands to pull the latest definitions
* `make clean-defs` - totally removes the cloned definitions
* `BRANCH=<branch> USER=<user> make point-to-defs-branch` - lets you update your defs to point at a fork and branch. Example: `BRANCH=issue-24 USER=ppeble make-point-defs-branch`. Run `make clean-defs` before this!
* `make point-to-defs-master` - points you back at the `holidays/definitions` repo and the master branch. Run `make clean-defs` before this!
