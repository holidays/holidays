
setup: update-defs
	bundle install

generate:
	bundle exec rake generate

test:
	rm -rf reports
	bundle exec rake test

test-smoke:
	bundle exec rake test:smoke

test-contract:
	bundle exec rake test:contract

test-integration:
	bundle exec rake test:integration

test-e2e:
	bundle exec rake test:e2e

console:
	bundle exec rake console

test-region:
	bundle exec rake test_region $(REGION)

build: clean
	bundle exec gem build holidays.gemspec

push:
	bundle exec gem push $(GEM)

update-defs: definitions/
	git submodule update --init --remote --recursive

definitions: point-to-defs-master

point-to-defs-branch:
	git submodule add -b $(BRANCH) https://github.com/$(USER)/definitions.git ./definitions/

point-to-defs-master:
	git submodule add https://github.com/holidays/definitions definitions/

reset-defs-to-master:
	git -C definitions checkout $$(git ls-tree origin/master -- definitions | awk '{print $$3}')

clean-defs:
	git rm -f definitions
	rm -rf .git/modules/definitions
	git config -f .git/config --remove-section submodule.definitions 2> /dev/null

clean:
	rm -rf holidays-*.gem
	rm -rf reports
	rm -rf coverage

.PHONY: setup test test-smoke test-contract test-integration test-e2e generate console build push update-defs test-region reset-defs-to-master clean-defs point-to-defs-master point-to-defs-branch clean definitions
