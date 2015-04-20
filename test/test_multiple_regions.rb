require File.expand_path(File.dirname(__FILE__)) + '/test_helper'
require 'holidays/gb'
require 'holidays/ie'

class MultipleRegionsTests < Test::Unit::TestCase
  def setup
    @date = Date.civil(2008,1,1)
  end

  def test_defining_holidays
    h = Holidays.on(Date.civil(2008,12,26), :ie)
    assert_equal 'St. Stephen\'s Day', h[0][:name]

    h = Holidays.on(Date.civil(2008,5,9), :gb_)
    assert_equal 'Liberation Day', (h[0] || {})[:name]


    h = Holidays.on(Date.civil(2008,5,9), :je)
    assert_equal 'Liberation Day', h[0][:name]

    h = Holidays.on(Date.civil(2008,5,9), :gb)
    assert h.empty?
  end
end
