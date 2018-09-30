require 'simplecov'

SimpleCov.minimum_coverage 99
SimpleCov.coverage_dir 'reports/coverage'
SimpleCov.start do
  add_filter 'lib/generated_definitions/'
  add_filter 'lib/holidays/factory/'
end
