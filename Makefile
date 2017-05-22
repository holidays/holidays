default: test

setup: update_defs
	bundle install

generate:
	bundle exec rake generate

test:
	bundle exec rake test

console:
	bundle exec rake console

test_region:
	bundle exec rake test_region $(REGION)

build: clean
	bundle exec gem build holidays.gemspec

push:
	bundle exec gem push $(GEM)

update_defs:
	git submodule update --init --remote --recursive

clean:
	rm -rf holidays-*.gem
	rm -rf reports
	rm -rf coverage

.PHONY: setup test generate
