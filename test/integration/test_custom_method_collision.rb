require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class CustomMethodCollisionTest < Test::Unit::TestCase
  def test_redefining_a_builtin_method_raises_and_registers_nothing
    error = assert_raises Holidays::DuplicateCustomMethod do
      Holidays.load_custom('test/integration/data/test_custom_method_collision_defs.yaml')
    end
    assert_match(/easter\(year\)/, error.message)

    assert_raises Holidays::InvalidRegion do
      Holidays.on(Date.civil(2024, 1, 1), :custom_method_collision)
    end

    assert_equal 'Easter Sunday', Holidays.on(Date.civil(2024, 3, 31), :us, :informal).first[:name]
  end
end
