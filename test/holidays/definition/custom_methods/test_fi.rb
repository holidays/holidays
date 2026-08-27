require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/fi'

class DefinitionCustomMethodsFITests < Test::Unit::TestCase
  def setup
    @subject = Holidays::Definition::CustomMethods::FI
  end

  def test_fi_juhannusaatto_returns_friday_between_june_19_and_25
    assert_equal Date.civil(2024, 6, 21), @subject.fi_juhannusaatto(2024)
    assert_equal Date.civil(2025, 6, 20), @subject.fi_juhannusaatto(2025)
    # 2021-06-19 is a Saturday, so it rolls forward a full week.
    assert_equal Date.civil(2021, 6, 25), @subject.fi_juhannusaatto(2021)
  end

  def test_fi_juhannuspaiva_returns_saturday_between_june_20_and_26
    assert_equal Date.civil(2024, 6, 22), @subject.fi_juhannuspaiva(2024)
    assert_equal Date.civil(2025, 6, 21), @subject.fi_juhannuspaiva(2025)
  end

  def test_fi_pyhainpaiva_returns_saturday_between_oct_31_and_nov_6
    assert_equal Date.civil(2024, 11, 2), @subject.fi_pyhainpaiva(2024)
    assert_equal Date.civil(2025, 11, 1), @subject.fi_pyhainpaiva(2025)
  end
end
