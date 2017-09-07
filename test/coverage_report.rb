require 'simplecov'
require 'simplecov-rcov'

SimpleCov.minimum_coverage 99
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.coverage_dir 'reports/coverage'
SimpleCov.start do
  add_filter 'lib/generated_definitions/'
  add_filter 'lib/holidays/factory/'
end
