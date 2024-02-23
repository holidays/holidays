require __dir__ + '/../test_helper'

# This file is generated by the Ruby Holiday gem.
#
# Definitions loaded: definitions/sg.yaml
class SgDefinitionTests < Test::Unit::TestCase # :nodoc:
  def test_sg
    puts Holidays.on(Date.civil(2014, 1, 1), [:sg], [:informal])
    assert_equal "New Year's Day", (Holidays.on(Date.civil(2014, 1, 1), [:sg], [:informal])[0] || {})[:name]

    assert_equal 'Good Friday', (Holidays.on(Date.civil(2014, 4, 18), [:sg], [:informal])[0] || {})[:name]

    assert_equal 'Labour Day', (Holidays.on(Date.civil(2014, 5, 1), [:sg], [:informal])[0] || {})[:name]

    assert_equal 'National Day', (Holidays.on(Date.civil(2014, 8, 9), [:sg], [:informal])[0] || {})[:name]

    assert_equal 'Christmas Day', (Holidays.on(Date.civil(2014, 12, 25), [:sg], [:informal])[0] || {})[:name]

    assert_equal "Lunar New Year's Day", (Holidays.on(Date.civil(2016, 2, 8), [:sg], [:observed])[0] || {})[:name]

    assert_equal 'The second day of Lunar New Year',
                 (Holidays.on(Date.civil(2016, 2, 9), [:sg], [:observed])[0] || {})[:name]

    assert_equal 'Deepavali', (Holidays.on(Date.civil(2077, 11, 15), [:sg], [:observed])[0] || {})[:name]

    assert_equal 'Hari Raya Haji', (Holidays.on(Date.civil(2025, 6, 6), [:sg], [:observed])[0] || {})[:name]

    assert_equal 'Hari Raya Puasa', (Holidays.on(Date.civil(2025, 3, 31), [:sg], [:observed])[0] || {})[:name]

    assert_equal 'Vesak Day', (Holidays.on(Date.civil(2025, 5, 12), [:sg], [:observed])[0] || {})[:name]
  end
end
