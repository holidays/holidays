require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/validator/region'

class RegionValidatorTests < Test::Unit::TestCase
  def setup
    @regions_repo = mock()
    @regions_repo.stubs(:exists?).returns(false)

    @subject = Holidays::Definition::Validator::Region.new(@regions_repo)
  end

  def test_returns_true_if_region_exists_in_generated_files
    assert(@subject.valid?(:us))
    assert(@subject.valid?(:federal_reserve))
    assert(@subject.valid?(:ecb_target))
    assert(@subject.valid?(:gb))
    assert(@subject.valid?(:jp))
  end

  def test_returns_true_if_region_is_in_regions_repository
    @regions_repo.expects(:exists?).with(:custom).returns(true)
    assert(@subject.valid?(:custom))
  end

  def test_returns_false_if_region_does_not_exist_in_generated_files_or_regions_repo
    @regions_repo.expects(:exists?).with(:unknown_region).returns(false)
    assert_equal(false, @subject.valid?(:unknown_region))
  end

  def test_returns_false_if_region_is_not_a_symbol
    assert_equal(false, @subject.valid?('not-a-symbol'))
  end

  def test_returns_true_if_subregion
    assert(@subject.valid?(:ca_qc))
  end

  def test_returns_true_if_region_is_any
    assert(@subject.valid?(:any))
  end

  def test_returns_true_if_wildcard_region_is_valid
    assert(@subject.valid?(:gb_))
  end

  def test_returns_false_if_wildcard_region_is_invalid
    assert_equal(false, @subject.valid?(:somethingweird_))
  end
end
