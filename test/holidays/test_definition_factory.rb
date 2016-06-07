require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/definition_factory'

class DefinitionFactoryTests < Test::Unit::TestCase
  def test_definition_file_parser
    assert Holidays::DefinitionFactory.file_parser.is_a?(Holidays::Definition::Context::Generator)
  end

  def test_definition_source_generator
    assert Holidays::DefinitionFactory.source_generator.is_a?(Holidays::Definition::Context::Generator)
  end

  def test_definition_merger
    assert Holidays::DefinitionFactory.merger.is_a?(Holidays::Definition::Context::Merger)
  end

  def test_holidays_by_month_repository
    assert Holidays::DefinitionFactory.holidays_by_month_repository.is_a?(Holidays::Definition::Repository::HolidaysByMonth)
  end

  def test_regions_repository
    assert Holidays::DefinitionFactory.regions_repository.is_a?(Holidays::Definition::Repository::Regions)
  end

  def test_cache_repository
    assert Holidays::DefinitionFactory.cache_repository.is_a?(Holidays::Definition::Repository::Cache)
  end

  def test_proc_result_cache_repository
    assert Holidays::DefinitionFactory.proc_result_cache_repository.is_a?(Holidays::Definition::Repository::ProcResultCache)
  end

  def test_custom_method_parser
    assert Holidays::DefinitionFactory.custom_method_parser.is_a?(Holidays::Definition::Parser::CustomMethod)
  end

  def test_custom_method_source_decorator
    assert Holidays::DefinitionFactory.custom_method_source_decorator.is_a?(Holidays::Definition::Decorator::CustomMethodSource)
  end

  def test_custom_method_validator
    assert Holidays::DefinitionFactory.custom_method_validator.is_a?(Holidays::Definition::Validator::CustomMethod)
  end

  def test_region_validator
    assert Holidays::DefinitionFactory.region_validator.is_a?(Holidays::Definition::Validator::Region)
  end

  def test_function_processor
    assert Holidays::DefinitionFactory.function_processor.is_a?(Holidays::Definition::Context::FunctionProcessor)
  end
end
