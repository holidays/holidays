require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/finder/context/parse_options'

#TODO This set of tests need love. Since the class itself requires actual
#     definition files we have real defs in here, meaning that these tests
#     could break if a definition is removed/changed.
#     Also, there are no actual tests that the files are actually required.
#     We need a mechanism to load things from the defs and then BOOM. We can test
#     that this mechanism is called.
class ParseOptionsTests < Test::Unit::TestCase
  def setup
    @regions_repo = mock()

    @region_validator = mock()
    @region_validator.stubs(:valid?).returns(true)

    # As mentioned above, this set of tests is NOT isolated. We need
    # the real merger code here.
    @definition_merger = Holidays::DefinitionFactory.merger

    @subject = Holidays::Finder::Context::ParseOptions.new(
      @regions_repo,
      @region_validator,
      @definition_merger,
    )
  end

  def test_returns_observed_true_if_options_contains_observed_flag
    @regions_repo.expects(:exists?).returns(false)
    regions, observed, informal = @subject.call([:ca, :observed])
    assert_equal(true, observed)
  end

  def test_returns_observed_false_if_options_contains_observed_flag
    @regions_repo.expects(:exists?).returns(false)
    regions, observed, informal = @subject.call([:ca])
    assert_equal(false, observed)
  end

  def test_returns_informal_true_if_options_contains_informal_flag
    @regions_repo.expects(:exists?).returns(false)
    regions, observed, informal = @subject.call([:ca, :informal])
    assert_equal(true, informal)
  end

  def test_returns_informal_false_if_options_contains_informal_flag
    @regions_repo.expects(:exists?).returns(false)
    regions, observed, informal = @subject.call([:ca])
    assert_equal(false, informal)
  end

  def test_returns_any_if_no_regions_are_provided
    regions, observed, informal = @subject.call(:informal)
    assert_equal([:any], regions)
  end

  def test_wildcard_regions_are_removed_if_found
    @regions_repo.expects(:exists?).with(:ch).returns(true)
    @regions_repo.expects(:exists?).with(:ch_zh).returns(true)
    @regions_repo.expects(:search).with('ch_').returns([:ch_zh])

    regions, observed, informal = @subject.call([:ch_])
    assert_equal(false, regions.include?(:ch_))
  end

  def test_raises_error_if_regions_are_invalid
    @region_validator.stubs(:valid?).returns(false)

    assert_raise Holidays::UnknownRegionError do
      @subject.call([:unknown_region])
    end
  end
end
