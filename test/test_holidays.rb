require File.dirname(__FILE__) + '/test_helper'

class HolidaysTests < Test::Unit::TestCase

  def setup
    @date = Date.civil(2008,1,1)
  end

  def test_on
    h = Holidays.on(Date.civil(2008,9,1), :ca)
    assert_equal 'Labour Day', h[0][:name]

    holidays = Holidays.on(Date.civil(2008,7,1), :ca)
    assert_equal 1, holidays.length

    holidays = Holidays.on(Date.civil(2008,7,4), :ca)
    assert_equal 0, holidays.length
  end

  def test_between
    holidays = Holidays.between(Date.civil(2008,7,1), Date.civil(2008,7,31), :ca)
    assert_equal 1, holidays.length
    
    holidays = Holidays.between(Date.civil(2008,7,2), Date.civil(2008,7,31), :ca)
    assert_equal 0, holidays.length
  end

  def test_requires_valid_regions
    assert_raises Holidays::UnkownRegionError do
      Holidays.on(Date.civil(2008,1,1), :xx)
    end

    assert_raises Holidays::UnkownRegionError do
      Holidays.on(Date.civil(2008,1,1), [:ca,:xx])
    end

    assert_raises Holidays::UnkownRegionError do
      Holidays.between(Date.civil(2008,1,1), Date.civil(2008,12,31), [:ca,:xx])
    end
  end

  def test_region_params
    holidays = Holidays.on(@date, :ca)
    assert_equal 1, holidays.length

    holidays = Holidays.on(@date, [:ca_bc,:ca])
    assert_equal 1, holidays.length
  end
  
  def test_any_region
    # Should return Victoria Day and Father's Day
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :ca)
    assert_equal 2, holidays.length

    # Should return Victoria Day, Father's Day and National Patriotes Day
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :any)
    assert_equal 3, holidays.length
  end
  
  def test_sub_regions
    # Should return Victoria Day and Father's Day
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :ca)
    assert_equal 2, holidays.length

    # Should return Victoria Day, Father's Day and National Patriotes Day
    holidays = Holidays.between(Date.civil(2008,5,1), Date.civil(2008,5,31), :ca_qc)
    assert_equal 3, holidays.length
  end
end
