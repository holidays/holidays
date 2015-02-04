# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/graceway.yaml
  #
  # To use the definitions in this file, load it right after you load the 
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/graceway'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module Graceway # :nodoc:
    def self.defined_regions
      [:graceway]
    end

    def self.holidays_by_month
      {
              0 => [{:function => lambda { |year| Holidays.easter(year)-46 }, :function_id => "easter(year)-46", :name => "Ash Wednesday", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.easter(year)-46 }, :function_id => "easter(year)-46", :length => :46, :name => "Lent", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.easter(year)-7 }, :function_id => "easter(year)-7", :name => "Palm Sunday", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.passover_start(year) }, :function_id => "passover_start(year)", :length => :8, :name => "Passover", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.easter(year)-2 }, :function_id => "easter(year)-2", :name => "Good Friday", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.easter(year) }, :function_id => "easter(year)", :name => "Easter Sunday", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.easter(year)+49 }, :function_id => "easter(year)+49", :name => "Pentecost", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.easter(year)+56 }, :function_id => "easter(year)+56", :name => "Trinity Sunday", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.advent_sunday(year) }, :function_id => "advent_sunday(year)", :name => "Advent", :regions => [:graceway]}],
      1 => [{:mday => 1, :name => "New Years", :regions => [:graceway]},
            {:wday => 1, :week => 3, :name => "Martin Luther King Jr", :regions => [:graceway]},
            {:wday => 0, :week => 3, :name => "Sanctity of Life Week", :regions => [:graceway]}],
      2 => [{:wday => 0, :week => 1, :name => "Superbowl Sunday", :regions => [:graceway]},
            {:mday => 14, :name => "Valentine's Day", :regions => [:graceway]}],
      3 => [{:wday => 0, :week => 2, :name => "Daylight Savings Begins", :regions => [:graceway]},
            {:wday => 0, :week => 1, :hide_date => true, :name => "Spring Events", :regions => [:graceway]},
            {:mday => 17, :name => "St Patrick's Day", :regions => [:graceway]}],
      5 => [{:wday => 4, :week => 1, :name => "National Day of Prayer", :regions => [:graceway]},
            {:wday => 0, :week => 2, :name => "Mothers Day", :regions => [:graceway]},
            {:wday => 0, :week => 3, :hide_date => true, :name => "Graduation", :regions => [:graceway]},
            {:wday => 1, :week => -1, :name => "Memorial Day", :regions => [:graceway]}],
      6 => [{:wday => 0, :week => 1, :hide_date => true, :name => "Summer Events", :regions => [:graceway]},
            {:wday => 0, :week => 3, :name => "Fathers Day", :regions => [:graceway]}],
      7 => [{:mday => 4, :name => "Independence Day", :regions => [:graceway]},
            {:wday => 0, :week => 2, :hide_date => true, :name => "VBS", :regions => [:graceway]}],
      8 => [{:wday => 0, :week => 2, :hide_date => true, :name => "Back to School", :regions => [:graceway]},
            {:wday => 0, :week => 1, :hide_date => true, :name => "Fall Events", :regions => [:graceway]}],
      9 => [{:wday => 1, :week => 1, :name => "Labor Day", :regions => [:graceway]},
            {:wday => 3, :week => 4, :name => "See You at the Pole", :regions => [:graceway]}],
      10 => [{:wday => 0, :week => 2, :name => "Pastor Appreciation", :regions => [:graceway]},
            {:mday => 31, :name => "Halloween", :regions => [:graceway]},
            {:mday => 31, :name => "Reformation Day", :regions => [:graceway]}],
      11 => [{:wday => 0, :week => 1, :name => "Daylight Savings Ends", :regions => [:graceway]},
            {:function => lambda { |year| Holidays.election_day(year) }, :function_id => "election_day(year)", :name => "Election Day", :regions => [:graceway]},
            {:mday => 11, :name => "Veterans Day", :regions => [:graceway]},
            {:wday => 4, :week => 4, :name => "Thanksgiving", :regions => [:graceway]}],
      12 => [{:wday => 0, :week => 1, :hide_date => true, :name => "Winter Events", :regions => [:graceway]},
            {:mday => 25, :name => "Christmas Day", :regions => [:graceway]}]
      }
    end
  end

def self.advent_sunday(year)
  d = Date.new(year, 11, -1)
  d -= (d.wday - 4) % 7
  d + 3
end


def self.election_day(year)
  d = Date.new(year, 11, 1)
  if d.wday == 2
    d = Date.calculate_mday(year, 11, :second, 2)
  else
    d = Date.calculate_mday(year, 11, :first, 2)
  end
end



end

Holidays.merge_defs(Holidays::Graceway.defined_regions, Holidays::Graceway.holidays_by_month)