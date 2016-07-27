require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/finder_factory'

class FinderFactoryTests < Test::Unit::TestCase
  def test_search
    assert Holidays::FinderFactory.search.is_a?(Holidays::Finder::Context::Search)
  end

  def test_between
    assert Holidays::FinderFactory.between.is_a?(Holidays::Finder::Context::Between)
  end

  def test_next_holiday
    assert Holidays::FinderFactory.next_holiday.is_a?(Holidays::Finder::Context::NextHoliday)
  end

  def test_year_holiday
    assert Holidays::FinderFactory.year_holiday.is_a?(Holidays::Finder::Context::YearHoliday)
  end
end
