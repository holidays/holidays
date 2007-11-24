require File.dirname(__FILE__) + '/test_helper'
require 'holidays/europe'
class RegionTests < Test::Unit::TestCase
  # ==== Netherlands
  # New Year's Day     1 January
  # Good Friday   21 March
  # Easter Sunday   23 March
  # Easter Monday   24 March
  # Queen's Birthday  30 April
  # Ascension Day   1 May
  # Liberation Day  5 May
  # Whit Sunday   11 May
  # Whit Monday   12 May
  # Christmas Day   25 December
  # Boxing Day  26 December
  def test_nl
    {Date.civil(2008,1,1) => 'Nieuwjaar', 
     Date.civil(2008,3,21) => 'Goede Vrijdag', 
     Date.civil(2008,3,23) => 'Pasen',
     Date.civil(2008,3,24) => 'Pasen',
     Date.civil(2008,4,30) => 'Koninginnedag',
     Date.civil(2008,5,1) => 'Hemelvaartsdag', # Ascension, Easter+39
     Date.civil(2008,5,5) => 'Bevrijdingsdag',
     Date.civil(2008,5,11) => 'Pinksteren', # Pentecost, Easter+49
     Date.civil(2008,5,12) => 'Pinksteren', # Pentecost, Easter+50
     Date.civil(2008,12,25) => 'Kerstmis',
     Date.civil(2008,12,26) => 'Kerstmis'}.each do |date, name|
      assert_equal name, Holidays.on(date, :nl)[0][:name]
    end
  end
end
