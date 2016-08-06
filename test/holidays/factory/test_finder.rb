require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

require 'holidays/factory/finder'

class FinderFactoryTests < Test::Unit::TestCase
  def test_search
    assert Holidays::Factory::Finder.search.is_a?(Holidays::Finder::Context::Search)
  end

  def test_between
    assert Holidays::Factory::Finder.between.is_a?(Holidays::Finder::Context::Between)
  end

  def test_next_holiday
    assert Holidays::Factory::Finder.next_holiday.is_a?(Holidays::Finder::Context::NextHoliday)
  end

  def test_year_holiday
    assert Holidays::Factory::Finder.year_holiday.is_a?(Holidays::Finder::Context::YearHoliday)
  end

  def test_parse_options_factory
    assert Holidays::Factory::Finder.parse_options.is_a?(Holidays::Finder::Context::ParseOptions)
  end
end
