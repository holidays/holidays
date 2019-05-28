# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# This file is generated by the Ruby Holiday gem.
#
# Definitions loaded: definitions/ecb_target.yaml
class Ecb_targetDefinitionTests < Test::Unit::TestCase  # :nodoc:

  def test_ecb_target
    assert_equal "New Year's Day", (Holidays.on(Date.civil(2013, 1, 1), [:ecb_target])[0] || {})[:name]

    assert_equal "Labour Day", (Holidays.on(Date.civil(2013, 5, 1), [:ecb_target])[0] || {})[:name]

    assert_equal "Good Friday", (Holidays.on(Date.civil(2013, 3, 29), [:ecb_target])[0] || {})[:name]

    assert_equal "Easter Monday", (Holidays.on(Date.civil(2013, 4, 1), [:ecb_target])[0] || {})[:name]

    assert_equal "Christmas Day", (Holidays.on(Date.civil(2013, 12, 25), [:ecb_target])[0] || {})[:name]

    assert_equal "Christmas Holiday", (Holidays.on(Date.civil(2013, 12, 26), [:ecb_target])[0] || {})[:name]

    assert_equal "Good Friday", (Holidays.on(Date.civil(2013, 3, 29), [:ecb_target])[0] || {})[:name]

    assert_equal "Easter Monday", (Holidays.on(Date.civil(2013, 4, 1), [:ecb_target])[0] || {})[:name]

  end
end