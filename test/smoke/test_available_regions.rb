require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class AvailableRegionsTests < Test::Unit::TestCase
  def setup
    @date = Date.civil(2008,1,1)
  end

  def test_available_regions_returns_array
    assert Holidays.available_regions.is_a?(Array)
  end

  def test_available_regions_returns_array_of_symbols
    Holidays.available_regions.each do |r|
      assert r.is_a?(Symbol)
    end
  end

end
