require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# See https://github.com/holidays/holidays/issues/344 for more info on why
# these specific integration tests exist.
class MultipleRegionsWithConflictsTests < Test::Unit::TestCase
  def test_corpus_christi_returns_correctly_for_co_even_if_br_is_loaded_first
    result = Holidays.on(Date.new(2014, 6, 19), :br)
    assert_equal 1, result.count
    assert_equal 'Corpus Christi', result.first[:name]

    result = Holidays.on(Date.new(2014, 6, 23), :co)
    assert_equal 1, result.count
    assert_equal 'Corpus Christi', result.first[:name]
  end

  def test_custom_loaded_region_returns_correct_value_with_function_modifier_conflict_even_if_conflict_definition_is_loaded_first
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')
    result = Holidays.on(Date.new(2019, 6, 20), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Modifier', result.first[:name]

    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_2.yaml')
    result = Holidays.on(Date.new(2019, 6, 24), :multiple_with_conflict_2)
    assert_equal 1, result.count
    assert_equal 'With Function Modifier', result.first[:name]

    # Region 1 must still return the correct date even though region 2 was
    # loaded afterwards with a different function modifier.
    result = Holidays.on(Date.new(2019, 6, 20), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Modifier', result.first[:name]
  end

  def test_custom_loaded_region_returns_correct_value_when_two_regions_share_function_name_but_have_different_logic
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')

    result = Holidays.on(Date.new(2019, 9, 1), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]

    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_2.yaml')

    result = Holidays.on(Date.new(2019, 11, 1), :multiple_with_conflict_2)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]

    # Region 1 must still return the correct date even though region 2 was
    # loaded afterwards with the same function name but different logic.
    result = Holidays.on(Date.new(2019, 9, 1), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]
  end

  # Load region 2 first, then region 1 — the opposite of the test above.
  # The first-loaded method lands in @custom_methods; the second goes into
  # @regional_overrides. This reversal exercises the fallback path for the
  # first-loaded region rather than the override path.
  def test_custom_loaded_region_returns_correct_value_when_load_order_is_reversed
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_2.yaml')

    result = Holidays.on(Date.new(2019, 11, 1), :multiple_with_conflict_2)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]

    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')

    result = Holidays.on(Date.new(2019, 9, 1), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]

    # Region 2 must still return the correct date even though region 1 was
    # loaded afterwards with the same function name but different logic.
    result = Holidays.on(Date.new(2019, 11, 1), :multiple_with_conflict_2)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]
  end

  # Both regions define holidays with the same custom function name but
  # different Ruby logic and different holiday names. Because the names differ,
  # holidays_by_month keeps them as separate entries (no region merge). Conflict
  # resolution must still route each holiday to its own function implementation.
  def test_custom_loaded_region_returns_correct_value_when_function_name_is_shared_but_holiday_names_differ
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_2.yaml')

    result = Holidays.on(Date.new(2019, 9, 15), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name - Region 1', result.first[:name]

    result = Holidays.on(Date.new(2019, 11, 15), :multiple_with_conflict_2)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name - Region 2', result.first[:name]
  end

  # When two regions are queried together and both have a holiday that uses the
  # same function name but different logic, the search must evaluate the function
  # independently for each queried region and return the union of all matches.
  def test_simultaneous_multi_region_query_evaluates_each_region_function_independently
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_2.yaml')

    result = Holidays.on(Date.new(2019, 11, 1), :multiple_with_conflict_1, :multiple_with_conflict_2)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]

    result = Holidays.on(Date.new(2019, 9, 1), :multiple_with_conflict_1, :multiple_with_conflict_2)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]
  end

  # Canonical https://www.github.com/holidays/holidays/issues/344 scenario: two regions
  # share a function name but each implements it differently, so a single between() call
  # spanning both result dates must return one holiday entry per region — not just the
  # result from whichever region's function happens to be evaluated first.
  #
  # Region 1's function returns Sept 1; region 2's function returns Nov 1.
  # Querying Sept 1 to Nov 1 with both regions should produce two separate
  # 'With Function Only Same Function Name' entries, one per region.
  def test_simultaneous_multi_region_query_returns_one_result_per_region_in_a_single_call
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_2.yaml')

    result = Holidays.between(
      Date.new(2019, 9, 1),
      Date.new(2019, 11, 1),
      :multiple_with_conflict_1,
      :multiple_with_conflict_2,
    )

    matching = result.select { |h| h[:name] == 'With Function Only Same Function Name' }
    assert_equal 2, matching.count
    assert matching.any? { |h| h[:date] == Date.new(2019, 9, 1) }, 'expected region 1 result on Sept 1'
    assert matching.any? { |h| h[:date] == Date.new(2019, 11, 1) }, 'expected region 2 result on Nov 1'
  end

  # Tests the conflict resolution path for functions that take a date argument
  # and return a shifted date, as opposed to functions that return a fixed date
  # for a given year. This is the canonical scenario from https://www.github.com/holidays/holidays/issues/344:
  # two regions define the same function name with different shift logic.
  #
  # Region 1: shifts Jan 1 to the nearest upcoming Saturday.
  # Region 2: shifts Jan 1 to the nearest upcoming Sunday.
  #
  # Jan 1, 2025 is a Wednesday, so:
  #   Region 1 -> Jan 4, 2025 (Saturday, +3 days)
  #   Region 2 -> Jan 5, 2025 (Sunday,   +4 days)
  def test_date_transforming_functions_with_conflicting_logic_are_each_evaluated_independently
    Holidays.load_custom('test/data/test_date_transform_conflict_region_1.yaml')
    Holidays.load_custom('test/data/test_date_transform_conflict_region_2.yaml')

    # Single-region: each region resolves to its own shifted date.
    result = Holidays.on(Date.new(2025, 1, 4), :date_transform_conflict_1)
    assert_equal 1, result.count
    assert_equal 'Weekend Holiday', result.first[:name]

    result = Holidays.on(Date.new(2025, 1, 5), :date_transform_conflict_2)
    assert_equal 1, result.count
    assert_equal 'Weekend Holiday', result.first[:name]

    # Multi-region: a single call spanning both shifted dates must return one
    # result per region — each evaluated with its own function logic.
    result = Holidays.between(
      Date.new(2025, 1, 4),
      Date.new(2025, 1, 5),
      :date_transform_conflict_1,
      :date_transform_conflict_2,
    )

    matching = result.select { |h| h[:name] == 'Weekend Holiday' }
    assert_equal 2, matching.count
    assert matching.any? { |h| h[:date] == Date.new(2025, 1, 4) }, 'expected region 1 result on Jan 4 (Saturday)'
    assert matching.any? { |h| h[:date] == Date.new(2025, 1, 5) }, 'expected region 2 result on Jan 5 (Sunday)'
  end

  # Verifies the safe-overwrite path in CustomMethods#add: when the same
  # source is added again the method is simply overwritten and the holiday
  # definition repo de-duplicates via uniq!, so exactly one result is returned.
  def test_loading_the_same_custom_file_twice_does_not_duplicate_or_break_results
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')
    Holidays.load_custom('test/data/test_multiple_regions_with_conflicts_region_1.yaml')

    result = Holidays.on(Date.new(2019, 9, 1), :multiple_with_conflict_1)
    assert_equal 1, result.count
    assert_equal 'With Function Only Same Function Name', result.first[:name]
  end
end
