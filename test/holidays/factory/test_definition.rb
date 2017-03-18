require File.expand_path(File.dirname(__FILE__)) + '/../../test_helper'

require 'holidays/factory/definition'

class DefinitionFactoryTests < Test::Unit::TestCase
  def test_definition_file_parser
    assert Holidays::Factory::Definition.file_parser.is_a?(Holidays::Definition::Context::Generator)
  end

  def test_definition_source_generator
    assert Holidays::Factory::Definition.source_generator.is_a?(Holidays::Definition::Context::Generator)
  end

  def test_definition_merger
    assert Holidays::Factory::Definition.merger.is_a?(Holidays::Definition::Context::Merger)
  end

  def test_holidays_by_month_repository
    assert Holidays::Factory::Definition.holidays_by_month_repository.is_a?(Holidays::Definition::Repository::HolidaysByMonth)
  end

  def test_regions_repository
    assert Holidays::Factory::Definition.regions_repository.is_a?(Holidays::Definition::Repository::Regions)
  end

  def test_cache_repository
    assert Holidays::Factory::Definition.cache_repository.is_a?(Holidays::Definition::Repository::Cache)
  end

  def test_proc_result_cache_repository
    assert Holidays::Factory::Definition.proc_result_cache_repository.is_a?(Holidays::Definition::Repository::ProcResultCache)
  end

  def test_custom_method_parser
    assert Holidays::Factory::Definition.custom_method_parser.is_a?(Holidays::Definition::Parser::CustomMethod)
  end

  def test_custom_method_source_decorator
    assert Holidays::Factory::Definition.custom_method_source_decorator.is_a?(Holidays::Definition::Decorator::CustomMethodSource)
  end

  def test_custom_method_validator
    assert Holidays::Factory::Definition.custom_method_validator.is_a?(Holidays::Definition::Validator::CustomMethod)
  end

  def test_region_validator
    assert Holidays::Factory::Definition.region_validator.is_a?(Holidays::Definition::Validator::Region)
  end

  def test_function_processor
    assert Holidays::Factory::Definition.function_processor.is_a?(Holidays::Definition::Context::FunctionProcessor)
  end

  def test_regions_generator
    assert Holidays::Factory::Definition.regions_generator.is_a?(Holidays::Definition::Generator::Regions)
  end

  def test_definitions_loader
    assert Holidays::Factory::Definition.loader.is_a?(Holidays::Definition::Context::Load)
  end

end
