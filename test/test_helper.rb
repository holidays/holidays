$:.unshift(File.expand_path(File.dirname(__FILE__) + '../../lib/'))

$KCODE = 'u' if RUBY_VERSION =~ /^1\.8/

require 'rubygems'
require 'test/unit'
require 'date'
require 'holidays'
require 'holidays/ca'

module Holidays
  # Test region used for generating a holiday on Date.today
  module Test # :nodoc:
    DEFINED_REGIONS = [:test]

    HOLIDAYS_BY_MONTH = {
      Date.today.mon => [{:mday => Date.today.mday, :name => "Test Holiday", :regions => [:test]}]
    }
  end
end

Holidays.merge_defs(Holidays::Test::DEFINED_REGIONS, Holidays::Test::HOLIDAYS_BY_MONTH)
