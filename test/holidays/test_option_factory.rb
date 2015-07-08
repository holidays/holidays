require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/option_factory'

class OptionFactoryTests < Test::Unit::TestCase
  def test_parse_options_factory
    assert Holidays::OptionFactory.parse_options.is_a?(Holidays::Option::Context::ParseOptions)
  end
end
