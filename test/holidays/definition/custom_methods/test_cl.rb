require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/cl'

class CLCustomMethodsTests < Test::Unit::TestCase
  def test_indigenous_peoples_day_uses_the_statutory_date_in_2021
    assert_equal '2021-06-21', Holidays::Definition::CustomMethods::CL.indigenous_peoples_day_cl(2021).to_s
  end

  def test_indigenous_peoples_day_matches_the_winter_solstice_in_chile
    assert_equal '2022-06-21', Holidays::Definition::CustomMethods::CL.indigenous_peoples_day_cl(2022).to_s
    assert_equal '2024-06-20', Holidays::Definition::CustomMethods::CL.indigenous_peoples_day_cl(2024).to_s
    assert_equal '2027-06-21', Holidays::Definition::CustomMethods::CL.indigenous_peoples_day_cl(2027).to_s
    assert_equal '2028-06-20', Holidays::Definition::CustomMethods::CL.indigenous_peoples_day_cl(2028).to_s
  end

  def test_indigenous_peoples_day_uses_chile_time_not_utc
    # The 2029 solstice is 2029-06-21 01:48 UTC, which is still June 20 in Chile.
    assert_equal '2029-06-20', Holidays::Definition::CustomMethods::CL.indigenous_peoples_day_cl(2029).to_s
  end

  def test_indigenous_peoples_day_raises_outside_supported_range
    assert_raise(IndexError) { Holidays::Definition::CustomMethods::CL.indigenous_peoples_day_cl(2100) }
  end
end
