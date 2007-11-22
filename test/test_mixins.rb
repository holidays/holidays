require File.dirname(__FILE__) + '/test_helper'
require 'fixtures/ca'

class CATests < Test::Unit::TestCase
  def test_ca_victoria_day
    [Date.civil(2004,5,24), Date.civil(2005,5,23), Date.civil(2006,5,22),
     Date.civil(2007,5,21), Date.civil(2008,5,19)].each do |date|
      assert_equal 'Victoria Day', Holidays.by_day(date, :ca)[0][:name]
    end
  end
end
