require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/definitions'

class DefinitionsTests < Test::Unit::TestCase
  def test_definition_file_parser
    assert Holidays::Definitions.file_parser.is_a?(Holidays::Definitions::Generator)
  end

  def test_definition_source_generator
    assert Holidays::Definitions.source_generator.is_a?(Holidays::Definitions::Generator)
  end
end
