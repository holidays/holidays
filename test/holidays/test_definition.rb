require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/definition'

class DefinitionTests < Test::Unit::TestCase
  def test_definition_file_parser
    assert Holidays::Definition.file_parser.is_a?(Holidays::Definition::Generator)
  end

  def test_definition_source_generator
    assert Holidays::Definition.source_generator.is_a?(Holidays::Definition::Generator)
  end
end
