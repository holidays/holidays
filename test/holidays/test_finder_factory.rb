require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/finder_factory'

class FinderFactoryTests < Test::Unit::TestCase
  def test_finder_search
    assert Holidays::FinderFactory.search.is_a?(Holidays::Finder::Context::Search)
  end
end
