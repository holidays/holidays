require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/my'

# Regression anchor for holidays#392: Hari Raya Puasa (1 Shawwal) and Hari
# Raya Haji (10 Dhul-Hijjah) are derived from the arithmetic Islamic calendar,
# with GAZETTE_OVERRIDES pinning the years where Malaysia's civil gazette
# (set by the Yang di-Pertuan Agong on JAKIM's moon-sighting advice) landed a
# day off the arithmetic result. Years with no entry fall back to the
# calculation.
class MYCustomMethodsTests < Test::Unit::TestCase
  HARI_RAYA_PUASA = {
    2014 => '2014-07-28', 2015 => '2015-07-17', 2016 => '2016-07-06',
    2017 => '2017-06-25', 2018 => '2018-06-15', 2019 => '2019-06-05',
    2020 => '2020-05-24', 2021 => '2021-05-13', 2022 => '2022-05-03',
    2023 => '2023-04-22', 2024 => '2024-04-10', 2025 => '2025-03-31',
    2026 => '2026-03-21'
  }.freeze

  HARI_RAYA_HAJI = {
    2014 => '2014-10-05', 2015 => '2015-09-24', 2016 => '2016-09-12',
    2017 => '2017-09-01', 2018 => '2018-08-22', 2019 => '2019-08-11',
    2020 => '2020-07-31', 2021 => '2021-07-20', 2022 => '2022-07-10',
    2023 => '2023-06-29', 2024 => '2024-06-17', 2025 => '2025-06-07',
    2026 => '2026-05-27'
  }.freeze

  def test_hari_raya_puasa_matches_the_gazetted_dates
    HARI_RAYA_PUASA.each do |year, expected|
      assert_equal expected, Holidays::Definition::CustomMethods::MY.hari_raya_puasa(year).to_s
    end
  end

  def test_hari_raya_haji_matches_the_gazetted_dates
    HARI_RAYA_HAJI.each do |year, expected|
      assert_equal expected, Holidays::Definition::CustomMethods::MY.hari_raya_haji(year).to_s
    end
  end

  def test_hari_raya_puasa_uses_arithmetic_calendar_when_no_override
    assert_equal '2018-06-15', Holidays::Definition::CustomMethods::MY.hari_raya_puasa(2018).to_s
    assert_equal '2023-04-22', Holidays::Definition::CustomMethods::MY.hari_raya_puasa(2023).to_s
  end

  def test_hari_raya_haji_uses_arithmetic_calendar_when_no_override
    assert_equal '2018-08-22', Holidays::Definition::CustomMethods::MY.hari_raya_haji(2018).to_s
    assert_equal '2023-06-29', Holidays::Definition::CustomMethods::MY.hari_raya_haji(2023).to_s
  end

  def test_hari_raya_puasa_uses_override_instead_of_arithmetic
    assert_equal '2014-07-28', Holidays::Definition::CustomMethods::MY.hari_raya_puasa(2014).to_s
    assert_equal '2026-03-21', Holidays::Definition::CustomMethods::MY.hari_raya_puasa(2026).to_s
  end

  def test_hari_raya_haji_uses_override_instead_of_arithmetic
    assert_equal '2019-08-11', Holidays::Definition::CustomMethods::MY.hari_raya_haji(2019).to_s
    assert_equal '2017-09-01', Holidays::Definition::CustomMethods::MY.hari_raya_haji(2017).to_s
  end
end
