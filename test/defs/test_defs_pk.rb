# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# This file is generated by the Ruby Holiday gem.
#
# Definitions loaded: definitions/pk.yaml
class PkDefinitionTests < Test::Unit::TestCase  # :nodoc:

  def test_pk
    assert_equal "Kashmir Day", (Holidays.on(Date.civil(2017, 2, 5), [:pk])[0] || {})[:name]

    assert_equal "Kashmir Day", (Holidays.on(Date.civil(2018, 2, 5), [:pk])[0] || {})[:name]

    assert_equal "Kashmir Day", (Holidays.on(Date.civil(2019, 2, 5), [:pk])[0] || {})[:name]

    assert_equal "Pakistan Day", (Holidays.on(Date.civil(2017, 3, 23), [:pk])[0] || {})[:name]

    assert_equal "Pakistan Day", (Holidays.on(Date.civil(2018, 3, 23), [:pk])[0] || {})[:name]

    assert_equal "Pakistan Day", (Holidays.on(Date.civil(2019, 3, 23), [:pk])[0] || {})[:name]

    assert_equal "Labour Day", (Holidays.on(Date.civil(2017, 5, 1), [:pk])[0] || {})[:name]

    assert_equal "Labour Day", (Holidays.on(Date.civil(2018, 5, 1), [:pk])[0] || {})[:name]

    assert_equal "Labour Day", (Holidays.on(Date.civil(2019, 5, 1), [:pk])[0] || {})[:name]

    assert_equal "Independence Day", (Holidays.on(Date.civil(2017, 8, 14), [:pk])[0] || {})[:name]

    assert_equal "Independence Day", (Holidays.on(Date.civil(2018, 8, 14), [:pk])[0] || {})[:name]

    assert_equal "Independence Day", (Holidays.on(Date.civil(2019, 8, 14), [:pk])[0] || {})[:name]

    assert_equal "Quaid-i-Azam Day", (Holidays.on(Date.civil(2017, 12, 25), [:pk])[0] || {})[:name]

    assert_equal "Quaid-i-Azam Day", (Holidays.on(Date.civil(2018, 12, 25), [:pk])[0] || {})[:name]

    assert_equal "Quaid-i-Azam Day", (Holidays.on(Date.civil(2019, 12, 25), [:pk])[0] || {})[:name]

  end
end