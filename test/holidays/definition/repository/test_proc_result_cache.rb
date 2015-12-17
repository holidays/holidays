require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/repository/proc_result_cache'

class ProcResultCacheRepoTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::Definition::Repository::ProcResultCache.new
  end

  def test_lookup_stores_and_returns_result_of_function_if_it_is_not_present
    function = lambda { |year| Date.civil(year, 2, 1) - 1 }
    year = 2015

    assert_equal(Date.civil(year, 1, 31), @subject.lookup(function, year))
  end

  #FIXME This test stinks. I don't know how to show that the second invocation
  #      doesn't call the function. In rspec I could just do an expect().not_to
  #      but it doesn't seem like Mocha can do that? I'm punting.
  def test_lookup_simply_returns_result_of_cache_if_present_after_first_call
    function = lambda { |year| Date.civil(year, 2, 1) - 1 }
    year = 2015

    assert_equal(Date.civil(year, 1, 31), @subject.lookup(function, year))
  end

  #FIXME This test depends on easter being available. That's garbage.
  def test_lookup_correctly_processing_function_as_string
    function = "Holidays.easter(year)"
    year = 2015

    assert_equal(Date.civil(year, 4, 5), @subject.lookup(function, year))
  end
end
