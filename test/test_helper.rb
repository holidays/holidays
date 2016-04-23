require 'coveralls'
Coveralls.wear!

$:.unshift(File.expand_path(File.dirname(__FILE__) + '../../lib/'))

$KCODE = 'u' if RUBY_VERSION =~ /^1\.8/

require 'rubygems'
require 'test/unit'
require 'mocha/test_unit'
require 'date'
require 'holidays'
require 'holidays/core_extensions/date'

# Loads core extension for use in various definition tests as necessary
class Date
  include Holidays::CoreExtensions::Date
end

module Holidays
  # Test region used for generating a holiday on Date.today
  module Test # :nodoc:
    DEFINED_REGIONS = [:test]

    HOLIDAYS_BY_MONTH = {
      Date.today.mon => [{:mday => Date.today.mday, :name => "Test Holiday", :regions => [:test]}]
    }

    CUSTOM_METHODS = {}
  end
end

Holidays::DefinitionFactory.merger.call(Holidays::Test::DEFINED_REGIONS, Holidays::Test::HOLIDAYS_BY_MONTH, Holidays::Test::CUSTOM_METHODS)
