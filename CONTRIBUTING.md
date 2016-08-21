# How to contribute

There are multiple ways to help! We rely on users around the world to help keep our definitions accurate and up to date. In addition, pull requests to address bugs or implement new features are always welcome.

## Code of Conduct

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing. Everyone interacting with this project (or associated projects) is expected to abide by its terms.

## For definition updates

Our definitions are written in YAML. You can find a complete guide to our format in the [definitions README](definitions/README.md). We take the YAML definitions and generate final ruby classes that are loaded at runtime for fast calculations.

Here are the steps to take once you have a good idea on what you want to change:

* Fork the repository
* Edit desired definition YAML file(s) located under `definitions/`. If you are adding a new region be sure to update `definitions/index.yaml` as well
* Run `make generate` to generate updated final definitions (they will be located under `lib/generated_definitions/` and `test/defs/`)
* Run `make test` to ensure your changes did not introduce errors
* Open a PR with *all* of these changes. You *MUST* include the generated definition files and tests in your PR. There is no automatic process to generate definitions at this time

Including documentation with your updates is very much appreciated. A simple Wikipedia entry or government link in the comments alongside your changes would be perfect.

Lastly, note that there are many 'meta' regions. For example, there are regions for Europe, Scandinavia, and North America. If your new region(s) falls into these areas consider adding them. You can find these 'meta' regions in `definitions/index.yaml`.

## For non-definition functionality

* Fork the repository
* Make your changes
* Create a PR pointing back to `master`

Don't worry about versioning, we'll handle it on our end.

*Tests are required*. If your PR results in lower test coverage then it will not be accepted.

## Local development helpers

We have included a few handy tasks to help you troubleshoot and test:

* `make test` - runs the entire suite
* `REGION=<region> make test_region` - runs the tests for just that region. Make sure to run `make generate` after updating your YAML before running this!
* `make console` - launches an IRB session with the 'holidays' gem loaded for quick testing
