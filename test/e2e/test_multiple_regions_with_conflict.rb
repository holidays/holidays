require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# See https://github.com/holidays/holidays/issues/344 for background. Two
# regions may share a holiday or a function modifier, but two custom methods
# with the same name and different logic are rejected at load time.
#
# The custom method repository is process-wide, so every collision test loads
# region 1 first. That keeps these tests independent of run order: region 1 is
# always the registered owner and regions 2 and 3 are always the ones rejected.
class MultipleRegionsWithConflictsTests < Test::Unit::TestCase
  REGION_1 = 'test/e2e/data/test_multiple_regions_with_conflicts_region_1.yaml'
  REGION_2 = 'test/e2e/data/test_multiple_regions_with_conflicts_region_2.yaml'
  REGION_3 = 'test/e2e/data/test_multiple_regions_with_conflicts_region_3.yaml'
  MODIFIER_CONFLICT = 'test/e2e/data/test_multiple_regions_with_function_modifier_conflict.yaml'
  DATE_TRANSFORM_1 = 'test/data/test_date_transform_conflict_region_1.yaml'
  DATE_TRANSFORM_2 = 'test/data/test_date_transform_conflict_region_2.yaml'

  def test_corpus_christi_returns_correctly_for_co_even_if_br_is_loaded_first
    result = Holidays.on(Date.new(2014, 6, 19), :br)
    assert_equal 1, result.count
    assert_equal 'Corpus Christi', result.first[:name]

    result = Holidays.on(Date.new(2014, 6, 23), :co)
    assert_equal 1, result.count
    assert_equal 'Corpus Christi', result.first[:name]
  end

  def test_custom_loaded_region_returns_correct_value_with_function_modifier_conflict_even_if_conflict_definition_is_loaded_first
    Holidays.load_custom(REGION_1)
    result = Holidays.on(Date.new(2019, 6, 20), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Modifier', result.first[:name]

    Holidays.load_custom(MODIFIER_CONFLICT)
    result = Holidays.on(Date.new(2019, 6, 24), :multiple_with_modifier_conflict)
    assert_equal 1, result.count
    assert_equal 'With Function Modifier', result.first[:name]

    # Region 1 must still return the correct date even though another region
    # was loaded afterwards with a different function modifier.
    result = Holidays.on(Date.new(2019, 6, 20), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Modifier', result.first[:name]
  end

  def test_loading_a_second_region_that_redefines_a_custom_method_raises
    Holidays.load_custom(REGION_1)

    assert_raises Holidays::DuplicateCustomMethod do
      Holidays.load_custom(REGION_2)
    end

    assert_raises Holidays::DuplicateCustomMethod do
      Holidays.load_custom(REGION_3)
    end
  end

  def test_rejected_region_registers_nothing_and_leaves_the_owner_intact
    Holidays.load_custom(REGION_1)

    assert_raises Holidays::DuplicateCustomMethod do
      Holidays.load_custom(REGION_2)
    end

    assert_raises Holidays::InvalidRegion do
      Holidays.on(Date.new(2019, 11, 1), :multiple_with_conflict_2)
    end

    # Region 2's non-colliding method must not have been registered either.
    assert_nil Holidays::Factory::Definition.custom_methods_repository.find('conflict_custom_method_2(year)')

    result = Holidays.on(Date.new(2019, 9, 1), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]

    result = Holidays.on(Date.new(2019, 9, 15), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name - Region 1', result.first[:name]
  end

  def test_date_transforming_functions_with_conflicting_logic_raise
    Holidays.load_custom(DATE_TRANSFORM_1)

    error = assert_raises Holidays::DuplicateCustomMethod do
      Holidays.load_custom(DATE_TRANSFORM_2)
    end
    assert_match(/to_nearest_upcoming_weekend_day\(date\)/, error.message)

    # Jan 1, 2025 is a Wednesday; region 1 shifts it to Saturday Jan 4.
    result = Holidays.on(Date.new(2025, 1, 4), :date_transform_conflict_1)
    assert_equal 1, result.count
    assert_equal 'Weekend Holiday', result.first[:name]

    assert_raises Holidays::InvalidRegion do
      Holidays.on(Date.new(2025, 1, 5), :date_transform_conflict_2)
    end
  end

  # Reloading the identical file is a no-op: the method source is byte-identical
  # and the holiday definition repo de-duplicates via uniq!.
  def test_loading_the_same_custom_file_twice_does_not_duplicate_or_break_results
    Holidays.load_custom(REGION_1)
    Holidays.load_custom(REGION_1)

    result = Holidays.on(Date.new(2019, 9, 1), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]
  end
end
