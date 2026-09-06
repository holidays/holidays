require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/us'

# Coverage for the region-aware Independence Day observed shift
# (definitions#478). July 4 2026 is a Saturday, July 4 2027 is a Sunday.
class USCustomMethodsTests < Test::Unit::TestCase
  SUBJECT = Holidays::Definition::CustomMethods::US

  def test_independence_day_shifts_to_the_nearest_weekday_for_most_regions
    assert_equal Date.civil(2026, 7, 3), SUBJECT.independence_day(:us, Date.civil(2026, 7, 4))
    assert_equal Date.civil(2027, 7, 5), SUBJECT.independence_day(:us, Date.civil(2027, 7, 4))
    assert_equal Date.civil(2025, 7, 4), SUBJECT.independence_day(:us, Date.civil(2025, 7, 4))
  end

  def test_independence_day_moves_rhode_island_to_the_following_monday
    assert_equal Date.civil(2026, 7, 6), SUBJECT.independence_day(:us_ri, Date.civil(2026, 7, 4))
    assert_equal Date.civil(2027, 7, 5), SUBJECT.independence_day(:us_ri, Date.civil(2027, 7, 4))
    assert_equal Date.civil(2025, 7, 4), SUBJECT.independence_day(:us_ri, Date.civil(2025, 7, 4))
  end

  def test_independence_day_does_not_shift_for_texas
    assert_equal Date.civil(2026, 7, 4), SUBJECT.independence_day(:us_tx, Date.civil(2026, 7, 4))
    assert_equal Date.civil(2027, 7, 4), SUBJECT.independence_day(:us_tx, Date.civil(2027, 7, 4))
  end
end
