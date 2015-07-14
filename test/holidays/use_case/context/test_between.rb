require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/use_case/context/between'

# I am going to be a jerk and punt on testing this for right now. If the overall
# integration tests pass then I am happy. This class does too much at the moment
# and needs to be split up into somethig more manageable. I don't want to write
# a bunch of tests just for something I will tear apart.
#
# If this comment remains for more than a few weeks then you can publically ridicule
# me.
class BetweenTests < Test::Unit::TestCase
  def setup
    @cache_repo = mock()
    @options_parser = mock()
    @holidays_by_month_repo = mock()
    @day_of_month_calculator = mock()
    @proc_cache_repo = mock()

    @subject = Holidays::UseCase::Context::Between.new(
      @cache_repo,
      @options_parser,
      @holidays_by_month_repo,
      @day_of_month_calculator,
      @proc_cache_repo
    )
  end

  def test_returns_error_if_dates_are_missing
    assert_raise ArgumentError do
      @subject.call(nil, Date.civil(2015, 1, 1), :us)
    end

    assert_raise ArgumentError do
      @subject.call(Date.civil(2015, 1, 1), nil, :us)
    end
  end

  def test_cached_holidays_are_returned_if_present
    start_date = Date.civil(2015, 1, 1)
    end_date = Date.civil(2015, 1, 31)
    options = [:us, :informal]

    @cache_repo.expects(:find).with(start_date, end_date, options).returns({cached: 'data'})

    assert_equal({cached: 'data'}, @subject.call(start_date, end_date, *options))
  end
end
