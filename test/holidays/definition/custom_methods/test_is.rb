require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/is'

class DefinitionCustomMethodsISTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::Definition::CustomMethods::IS
  end

  def test_is_sumardagurinn_fyrsti_returns_first_thursday_after_april_18
    assert_equal Date.civil(2024, 4, 25), @subject.is_sumardagurinn_fyrsti(2024)
    assert_equal Date.civil(2025, 4, 24), @subject.is_sumardagurinn_fyrsti(2025)
    # 2020-04-18 is a Saturday.
    assert_equal Date.civil(2020, 4, 23), @subject.is_sumardagurinn_fyrsti(2020)
  end
end
