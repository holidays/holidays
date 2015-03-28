require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/definition_generator'

class DefinitionGeneratorTests < Test::Unit::TestCase
  def setup
    @generator = Holidays::DefinitionGenerator.new
  end

  def test_parse_definition_files_raises_error_if_argument_is_nil
    assert_raises ArgumentError do
      @generator.parse_definition_files(nil)
    end
  end

  def test_parse_definition_files_raises_error_if_files_are_empty
    assert_raises ArgumentError do
      @generator.parse_definition_files([])
    end
  end

  def test_parse_definition_files_correctly_parse_regions
    files = ['test/data/test_single_custom_holiday_defs.yaml']
    regions, rules_by_month, custom_methods, tests = @generator.parse_definition_files(files)

    assert_equal [:custom_single_file], regions
  end

  def test_parse_definitions_files_correctly_parse_rules_by_month
    files = ['test/data/test_single_custom_holiday_defs.yaml']
    regions, rules_by_month, custom_methods, tests = @generator.parse_definition_files(files)

    expected_rules_by_month = {
      6 => [
        {
          :mday    => 20,
          :name    => "Company Founding",
          :regions => [:custom_single_file]
        }
      ]
    }

    assert_equal expected_rules_by_month, rules_by_month
  end

  def test_parse_definition_files_correctly_parse_custom_methods
    files = ['test/data/test_single_custom_holiday_defs.yaml']
    regions, rules_by_month, custom_methods, tests = @generator.parse_definition_files(files)

    expected_custom_methods = {}
    assert_equal expected_custom_methods, custom_methods
  end

  def test_parse_definition_files_correctly_parse_tests
    files = ['test/data/test_single_custom_holiday_defs.yaml']
    regions, rules_by_month, custom_methods, tests = @generator.parse_definition_files(files)

    expected_tests = [[
        "{Date.civil(2013,6,20) => 'Company Founding'}.each do |date, name|\n  assert_equal name, (Holidays.on(date, :custom_single_file)[0] || {})[:name]\nend"
    ]]

    assert_equal expected_tests, tests
  end

  def test_generate_definition_source_correctly_generate_module_src

  end

  def test_generate_definition_source_correctly_genrate_test_src

  end

  #TODO add sad path for all above tests
  #TODO add some variations to cover all valid scenarios for above tests
end
