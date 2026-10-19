require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class WildcardRegionsTest < Test::Unit::TestCase
  # ca.rb also defines :us, so once us.rb has been loaded a :ca_ wildcard used
  # to pick up every US holiday too.
  def test_wildcard_does_not_include_other_countries_after_they_are_loaded
    Holidays.on(Date.civil(1982, 7, 5), :us)

    assert_equal [], Holidays.on(Date.civil(1982, 7, 5), :ca_ab_, :observed)
    assert_equal [], Holidays.on(Date.civil(1982, 7, 5), :mx_, :observed)
  end
end
