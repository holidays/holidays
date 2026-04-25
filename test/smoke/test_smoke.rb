require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class SmokeTests < Test::Unit::TestCase
  SAMPLE_DATES = [
    Date.civil(2023, 1, 1),
    Date.civil(2023, 7, 4),
    Date.civil(2023, 12, 25),
  ]

  def setup
    Holidays.load_all
    @regions = Holidays.available_regions
  end

  def test_all_regions_load_without_error
    assert @regions.is_a?(Array)
    assert @regions.count > 0
    assert @regions.all? { |r| r.is_a?(Symbol) }
  end

  def test_holidays_on_does_not_raise_for_any_region
    @regions.each do |region|
      SAMPLE_DATES.each do |date|
        assert_nothing_raised("Holidays.on raised for :#{region} on #{date}") do
          result = Holidays.on(date, region)
          assert result.is_a?(Array)
        end
      end
    end
  end

  def test_holidays_between_does_not_raise_for_any_region
    start_date = Date.civil(2023, 1, 1)
    end_date = Date.civil(2023, 12, 31)

    @regions.each do |region|
      assert_nothing_raised("Holidays.between raised for :#{region}") do
        result = Holidays.between(start_date, end_date, region)
        assert result.is_a?(Array)
      end
    end
  end

  def test_observed_flag_does_not_raise_for_any_region
    @regions.each do |region|
      SAMPLE_DATES.each do |date|
        assert_nothing_raised("Holidays.on with :observed raised for :#{region} on #{date}") do
          Holidays.on(date, region, :observed)
        end
      end
    end
  end

  def test_informal_flag_does_not_raise_for_any_region
    @regions.each do |region|
      SAMPLE_DATES.each do |date|
        assert_nothing_raised("Holidays.on with :informal raised for :#{region} on #{date}") do
          Holidays.on(date, region, :informal)
        end
      end
    end
  end

  def test_any_region_count_meets_or_exceeds_each_individual_region
    start_date = Date.civil(2023, 1, 1)
    end_date = Date.civil(2023, 12, 31)
    any_count = Holidays.between(start_date, end_date, :any).count

    @regions.each do |region|
      region_count = Holidays.between(start_date, end_date, region).count
      assert any_count >= region_count, ":any count (#{any_count}) is less than :#{region} count (#{region_count})"
    end
  end
end
