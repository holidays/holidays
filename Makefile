default: test

setup: update_defs
	bundle install

generate: update_defs
	bundle exec rake generate

test:
	bundle exec rake test

console:
	bundle exec rake console

test_region:
	bundle exec rake test_region $(REGION)

build: clean
	bundle exec gem build $(GEM)

push:
	bundle exec gem push holidays.gemspec

update_defs:
	git submodule update --init --remote --recursive

clean:
	rm -rf holidays-*.gem
	rm -rf reports
	rm -rf coverage

.PHONY: setup test generate
