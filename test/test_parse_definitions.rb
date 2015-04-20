require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class ParseDefinitionsTests < Test::Unit::TestCase

  def test_single_parse_definition_file
    module_src, test_src = Holidays.parse_definition_files_and_return_source(:test_region, 'test/data/test_single_custom_holiday_defs.yaml')

    assert_equal false, module_src.empty?
    assert_equal false, test_src.empty?
  end

  def test_parsing_without_def_file_results_in_error
    assert_raises ArgumentError do
      Holidays.parse_definition_files_and_return_source(:custom)
    end
  end

  def test_parsing_of_multiple_definition_files
    module_src, test_src = Holidays.parse_definition_files_and_return_source(:test_region_multiple, 'test/data/test_single_custom_holiday_defs.yaml', 'test/data/test_custom_govt_holiday_defs.yaml')

    assert_equal false, module_src.empty?
    assert_equal false, test_src.empty?
  end
end