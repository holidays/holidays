require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/custom_methods/ma'

# Regression anchor for holidays#392: Morocco's Eid al-Fitr and Eid al-Adha
# are derived from the arithmetic Hijri calendar, with a small override
# table for years where the Ministry of Habous and Islamic Affairs'
# proclaimed date differs from the arithmetic result.
class MACustomMethodsTests < Test::Unit::TestCase
  def test_eid_al_fitr_matches_arithmetic_calendar_when_no_override
    assert_equal '2018-06-15', Holidays::Definition::CustomMethods::MA.eid_al_fitr(2018).to_s
    assert_equal '2023-04-22', Holidays::Definition::CustomMethods::MA.eid_al_fitr(2023).to_s
  end

  def test_eid_al_adha_matches_arithmetic_calendar_when_no_override
    assert_equal '2018-08-22', Holidays::Definition::CustomMethods::MA.eid_al_adha(2018).to_s
    assert_equal '2023-06-29', Holidays::Definition::CustomMethods::MA.eid_al_adha(2023).to_s
  end

  def test_eid_al_fitr_uses_the_ministry_override_in_2022
    # Arithmetic calendar gives 2022-05-03; the ministry proclaimed 2022-05-02.
    assert_equal '2022-05-02', Holidays::Definition::CustomMethods::MA.eid_al_fitr(2022).to_s
  end

  def test_eid_al_adha_uses_the_ministry_override_in_2021
    # Arithmetic calendar gives 2021-07-20; the ministry proclaimed 2021-07-21.
    assert_equal '2021-07-21', Holidays::Definition::CustomMethods::MA.eid_al_adha(2021).to_s
  end
end
