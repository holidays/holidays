require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/tr'

# Regression anchor for definitions#377: every date the tr definition file
# previously carried as a fixed table must still be produced, now from the
# arithmetic calendar plus DIYANET_OVERRIDES. Years past the old table are
# covered too, to prove the holidays no longer silently disappear.
class TRCustomMethodsTests < Test::Unit::TestCase
  RAMADAN_FEAST = {
    2014 => '2014-07-28', 2015 => '2015-07-17', 2016 => '2016-07-05',
    2017 => '2017-06-25', 2018 => '2018-06-15', 2019 => '2019-06-04',
    2020 => '2020-05-24', 2021 => '2021-05-13', 2022 => '2022-05-02',
    2023 => '2023-04-21', 2024 => '2024-04-10', 2025 => '2025-03-30',
    2026 => '2026-03-20', 2027 => '2027-03-09', 2028 => '2028-02-26',
    2029 => '2029-02-15', 2030 => '2030-02-04', 2031 => '2031-01-25',
    2032 => '2032-01-14'
  }.freeze

  SACRIFICE_FEAST = {
    2014 => '2014-10-04', 2015 => '2015-09-24', 2016 => '2016-09-12',
    2017 => '2017-09-01', 2018 => '2018-08-21', 2019 => '2019-08-11',
    2020 => '2020-07-31', 2021 => '2021-07-20', 2022 => '2022-07-09',
    2023 => '2023-06-28', 2024 => '2024-06-16', 2025 => '2025-06-06',
    2026 => '2026-05-27', 2027 => '2027-05-16', 2028 => '2028-05-05',
    2029 => '2029-04-24', 2030 => '2030-04-13', 2031 => '2031-04-03',
    2032 => '2032-03-22'
  }.freeze

  def test_ramadan_feast_matches_the_diyanet_dates
    RAMADAN_FEAST.each do |year, expected|
      assert_equal expected, Holidays::Definition::CustomMethods::TR.ramadan_feast(year).to_s
    end
  end

  def test_sacrifice_feast_matches_the_diyanet_dates
    SACRIFICE_FEAST.each do |year, expected|
      assert_equal expected, Holidays::Definition::CustomMethods::TR.sacrifice_feast(year).to_s
    end
  end

  def test_dates_are_still_produced_well_beyond_the_old_table
    assert_equal '2040-10-08', Holidays::Definition::CustomMethods::TR.ramadan_feast(2040).to_s
    assert_equal '2045-10-22', Holidays::Definition::CustomMethods::TR.sacrifice_feast(2045).to_s
  end
end
