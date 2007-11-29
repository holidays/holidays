require File.dirname(__FILE__) + '/test_helper'

require 'holidays/north_america'

class North_AmericaTests < Test::Unit::TestCase

  def test_ca
    {Date.civil(2008,1,1) => 'New Year\'s Day', 
     Date.civil(2008,3,21) => 'Good Friday', 
     Date.civil(2008,3,24) => 'Easter Monday',
     Date.civil(2008,5,19) => 'Victoria Day',
     Date.civil(2008,7,1) => 'Canada Day',
     Date.civil(2008,9,1) => 'Labour Day',
     Date.civil(2008,10,13) => 'Thanksgiving',
     Date.civil(2008,11,11) => 'Rememberance Day',
     Date.civil(2008,12,25) => 'Christmas Day',
     Date.civil(2008,12,26) => 'Boxing Day'}.each do |date, name|
      assert_equal name, Holidays.on(date, :ca)[0][:name]
    end
  end

  def test_ca_victoria_day
    [Date.civil(2004,5,24), Date.civil(2005,5,23), Date.civil(2006,5,22),
     Date.civil(2007,5,21), Date.civil(2008,5,19)].each do |date|
      assert_equal 'Victoria Day', Holidays.on(date, :ca)[0][:name]
    end
  end

  # from 
  # - http://www.britishembassy.gov.uk/servlet/Front?pagename=OpenMarket/Xcelerate/ShowPage&c=Page&cid=1125561634963
  # - http://www.usembassy-mexico.gov/eng/holidays.html
  def test_mx
    {Date.civil(2007,1,1) => 'Año nuevo', 
     Date.civil(2007,2,5) => 'Día de la Constitución', 
     Date.civil(2007,5,1) => 'Día del Trabajo',
     Date.civil(2007,5,5) => 'Cinco de Mayo',
     Date.civil(2007,9,16) => 'Día de la Independencia',
     Date.civil(2007,11,1) => 'Todos los Santos',
     Date.civil(2007,11,2) => 'Los Fieles Difuntos',
     Date.civil(2007,11,19) => 'Día de la Revolución',
     Date.civil(2007,12,25) => 'Navidad'}.each do |date, name|
      assert_equal name, Holidays.on(date, :mx)[0][:name]
    end    

  
  end

  def test_us
    {Date.civil(2008,1,1) => 'New Year\'s Day', 
     Date.civil(2008,1,21) => 'Martin Luther King, Jr. Day',
     Date.civil(2008,2,18) => 'Presidents\' Day',
     Date.civil(2008,5,26) => 'Memorial Day',
     Date.civil(2008,7,4) => 'Independence Day',
     Date.civil(2008,9,1) => 'Labor Day',
     Date.civil(2008,10,13) => 'Columbus Day',
     Date.civil(2008,11,11) => 'Veterans Day',
     Date.civil(2008,11,27) => 'Thanksgiving',
     Date.civil(2008,12,25) => 'Christmas Day'}.each do |date, name|
      assert_equal name, Holidays.on(date, :us)[0][:name]
    end
  end


end

