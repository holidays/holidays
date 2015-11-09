require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class ParseDefinitionsTests < Test::Unit::TestCase
  def test_single_parse_definition_file
    custom_holiday_defs = 'test/data/test_single_custom_holiday_defs.yaml'
    module_src, test_src = Holidays.parse_definition_files_and_return_source(:test_region, custom_holiday_defs)

    assert_equal false, module_src.empty?
    assert_equal false, test_src.empty?
  end

  def test_parsing_without_def_file_results_in_error
    assert_raises ArgumentError do
      Holidays.parse_definition_files_and_return_source(:custom)
    end
  end

  def test_parsing_of_multiple_definition_files
    custom_holiday_defs = 'test/data/test_single_custom_holiday_defs.yaml'
    custom_gov_holiday_defs = 'test/data/test_custom_govt_holiday_defs.yaml'
    module_src, test_src = Holidays.parse_definition_files_and_return_source(:test_region_multiple,
                                                                             custom_holiday_defs,
                                                                             custom_gov_holiday_defs)

    assert_equal false, module_src.empty?
    assert_equal false, test_src.empty?
  end
end
