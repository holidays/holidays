# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# The lunar calendar tables cover lunar years 1900..2100. Queries whose own
# dates fall in that range must work, even though the dates driver pads
# them with a border month from the year after (or before).
class LunarTableRangeTests < Test::Unit::TestCase
  LUNAR_REGIONS = [:cn, :hk, :kr, :vn, :sg]

  def test_year_holidays_for_2049_and_2100
    LUNAR_REGIONS.each do |region|
      [2049, 2100].each do |year|
        holidays = Holidays.year_holidays([region], Date.civil(year, 1, 1))
        assert_not_empty holidays, "#{region} #{year}"
        assert(holidays.all? { |h| h[:date].year == year }, "#{region} #{year}")
      end
    end
  end

  def test_between_over_all_of_2049_and_2100
    LUNAR_REGIONS.each do |region|
      [2049, 2100].each do |year|
        holidays = Holidays.between(Date.civil(year, 1, 1), Date.civil(year, 12, 31), region)
        assert_not_empty holidays, "#{region} #{year}"
      end
    end
  end

  def test_on_last_and_first_supported_days
    LUNAR_REGIONS.each do |region|
      assert_nothing_raised { Holidays.on(Date.civil(2100, 12, 31), region) }
      assert_nothing_raised { Holidays.on(Date.civil(1900, 1, 1), region) }
      assert_nothing_raised { Holidays.on(Date.civil(2049, 12, 5), region) }
    end
  end

  def test_lunar_holidays_in_2100
    assert_includes names_on(Date.civil(2100, 2, 9), :cn), '春节'
    assert_includes names_on(Date.civil(2100, 4, 5), :cn), '清明节'
    assert_includes names_on(Date.civil(2100, 9, 18), :cn), '中秋节'
    assert_includes names_on(Date.civil(2100, 10, 12), :hk), 'Chung Yeung Festival'
    assert_includes names_on(Date.civil(2100, 9, 18), :kr), '추석'
    assert_includes names_on(Date.civil(2100, 4, 18), :vn), 'Giỗ tổ Hùng Vương'
  end

  def test_lunar_holidays_in_2049
    assert_includes names_on(Date.civil(2049, 2, 2), :cn), '春节'
    assert_includes names_on(Date.civil(2049, 9, 11), :kr), '추석'
  end

  def test_hong_kong_chung_yeung_2057_follows_the_observatory
    assert_includes names_on(Date.civil(2057, 10, 6), :hk), 'Chung Yeung Festival'
  end

  def test_query_past_the_tables_raises_unsupported_year_error
    LUNAR_REGIONS.each do |region|
      assert_raises(Holidays::UnsupportedYearError, region.to_s) do
        Holidays.year_holidays([region], Date.civil(2101, 1, 1))
      end
      assert_raises(Holidays::UnsupportedYearError, region.to_s) do
        Holidays.between(Date.civil(2101, 3, 1), Date.civil(2101, 3, 31), region)
      end
    end
  end

  def test_query_before_the_tables_raises_unsupported_year_error
    assert_raises(Holidays::UnsupportedYearError) do
      Holidays.year_holidays([:kr], Date.civil(1899, 1, 1))
    end
  end

  private

  def names_on(date, region)
    Holidays.on(date, region).map { |h| h[:name] }
  end
end
