require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/cn'

class CNCustomMethodsTests < Test::Unit::TestCase
  def test_qingming_follows_the_solar_term
    assert_equal '2008-04-04', Holidays::Definition::CustomMethods::CN.cn_qingming(2008).to_s
    assert_equal '2099-04-04', Holidays::Definition::CustomMethods::CN.cn_qingming(2099).to_s
  end

  def test_qingming_in_2100
    assert_equal '2100-04-05', Holidays::Definition::CustomMethods::CN.cn_qingming(2100).to_s
  end

  def test_qingming_outside_supported_years_raises_unsupported_year_error
    [1899, 2101].each do |year|
      error = assert_raises(Holidays::UnsupportedYearError) { Holidays::Definition::CustomMethods::CN.cn_qingming(year) }
      assert_equal "cn_qingming covers 1900..2100, got #{year}", error.message
    end
  end
end
