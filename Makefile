default: test

setup:
	bundle install

test:
	bundle exec rake test

generate:
	bundle exec rake generate

console:
	bundle exec rake console

test_region:
	bundle exec rake test_region

build:
	bundle exec gem build holidays.gemspec

push:
	bundle exec gem push holidays.gemspec

clean:
	rm -rf holidays-*.gem
	rm -rf reports
	rm -rf coverage

.PHONY: setup test generate
