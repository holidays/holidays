require 'simplecov'

# JRuby coverage reporting is inaccurate without --debug mode, resulting in
# artificially low numbers. Skip the minimum coverage check under JRuby.
SimpleCov.minimum_coverage 89 unless RUBY_PLATFORM == 'java' || ENV['SMOKE_TEST']

SimpleCov.add_filter [
  # Apparently simplecov doesn't automatically filter 'spec' or 'test' so we
  # have to do it manually.
  'test',

  # Only filtered because I tend to not see value in testing factories.
  'lib/holidays/factory/',

  # jruby coverage flips out here and doesn't count much of the large date
  # arrays used by this class. This results in an extremely low reported
  # coverage for this specific file but only in jruby, not other ruby versions.
  # Since it obliterates coverage percentages I'll filter it until I can come
  # up with a solution.
  'lib/holidays/date_calculator/lunar_date.rb',
]

SimpleCov.coverage_dir 'reports/coverage'
SimpleCov.start
