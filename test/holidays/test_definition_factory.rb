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
end