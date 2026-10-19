require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/context/merger'
require 'holidays/errors'

class MergerTests < Test::Unit::TestCase
  def setup
    @target_regions = [:new_region]
    @target_holidays = {0 => [:mday => 1, :name => "Test", :regions => [:test2, :test]]}
    @target_custom_methods = {"test_method" => Proc.new { |year| Date.civil(year, 1, 1) } }

    @holidays_repo = mock()
    @regions_repo = mock()
    @custom_methods_repo = mock()
    @cache_repo = mock()
    @proc_result_cache_repo = mock()

    @subject = Holidays::Definition::Context::Merger.new(
      @holidays_repo,
      @regions_repo,
      @custom_methods_repo,
      @cache_repo,
      @proc_result_cache_repo,
    )
  end

  def test_repos_are_called_to_add_regions_and_holidays
    @holidays_repo.expects(:add).with(@target_holidays)
    @regions_repo.expects(:add).with(@target_regions)
    @custom_methods_repo.expects(:add).with(@target_custom_methods, {})
    @cache_repo.expects(:reset!)
    @proc_result_cache_repo.expects(:reset!)

    @subject.call(@target_regions, @target_holidays, @target_custom_methods)
  end

  def test_caches_are_still_reset_when_a_repo_raises_mid_merge
    @holidays_repo.expects(:add).raises(StandardError, "boom")
    @regions_repo.stubs(:add)
    @custom_methods_repo.stubs(:add)

    @cache_repo.expects(:reset!)
    @proc_result_cache_repo.expects(:reset!)

    assert_raise(StandardError) do
      @subject.call(@target_regions, @target_holidays, @target_custom_methods)
    end
  end

  def test_custom_methods_are_added_before_regions_and_holidays
    adds = sequence('adds')
    @custom_methods_repo.expects(:add).in_sequence(adds)
    @regions_repo.expects(:add).in_sequence(adds)
    @holidays_repo.expects(:add).in_sequence(adds)
    @cache_repo.stubs(:reset!)
    @proc_result_cache_repo.stubs(:reset!)

    @subject.call(@target_regions, @target_holidays, @target_custom_methods)
  end

  def test_custom_method_collision_leaves_regions_and_holidays_untouched
    @custom_methods_repo.expects(:add).raises(Holidays::DuplicateCustomMethod, "dup")
    @regions_repo.expects(:add).never
    @holidays_repo.expects(:add).never
    @cache_repo.expects(:reset!)
    @proc_result_cache_repo.expects(:reset!)

    assert_raise(Holidays::DuplicateCustomMethod) do
      @subject.call(@target_regions, @target_holidays, @target_custom_methods)
    end
  end
end
