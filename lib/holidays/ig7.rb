# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/ig7.yaml
  #
  # To use the definitions in this file, load it right after you load the 
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/ig7'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module IG7 # :nodoc:
    def self.defined_regions
      [:ig7]
    end

    def self.holidays_by_month
      {
              0 => [{:function => lambda { |year| Holidays.easter(year)-46 }, :function_id => "easter(year)-46", :slug => "ash-wednesday", :name => "Ash Wednesday", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.easter(year)-46 }, :function_id => "easter(year)-46", :slug => "lent", :length => 43, :name => "Lent", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.easter(year)-7 }, :function_id => "easter(year)-7", :slug => "palm-sunday", :name => "Palm Sunday", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.passover_start(year) }, :function_id => "passover_start(year)", :slug => "passover", :length => 8, :name => "Passover", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.easter(year)-2 }, :function_id => "easter(year)-2", :slug => "good-friday", :name => "Good Friday", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.easter(year) }, :function_id => "easter(year)", :slug => "easter", :name => "Easter Sunday", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.easter(year)+49 }, :function_id => "easter(year)+49", :slug => "pentecost", :name => "Pentecost", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.easter(year)+56 }, :function_id => "easter(year)+56", :slug => "trinity-sunday", :name => "Trinity Sunday", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.advent_sunday(year) }, :function_id => "advent_sunday(year)", :slug => "advent", :date_end => "12/24", :name => "Advent", :regions => [:ig7]}],
      1 => [{:mday => 1, :slug => "new-years", :name => "New Year's", :regions => [:ig7]},
            {:wday => 1, :week => 3, :slug => "mlk-day", :name => "Martin Luther King Jr", :regions => [:ig7]},
            {:wday => 0, :week => 3, :slug => "sanctity-of-life", :name => "Sanctity of Life Week", :regions => [:ig7]}],
      2 => [{:wday => 0, :week => 2, :slug => "super-bowl-sunday", :name => "Super Bowl Sunday", :regions => [:ig7]},
            {:mday => 14, :slug => "valentines-day", :name => "Valentine's Day", :regions => [:ig7]}],
      3 => [{:wday => 0, :week => 2, :slug => "daylight-saving-begins", :name => "Daylight Saving Begins", :regions => [:ig7]},
            {:wday => 0, :week => 1, :hide_date => true, :slug => "spring", :name => "Spring Events", :regions => [:ig7]}],
      5 => [{:wday => 4, :week => 1, :slug => "national-day-of-prayer", :name => "National Day of Prayer", :regions => [:ig7]},
            {:wday => 0, :week => 2, :slug => "mothers-day", :name => "Mother's Day", :regions => [:ig7]},
            {:wday => 0, :week => 3, :hide_date => true, :slug => "graduation", :name => "Graduation", :regions => [:ig7]},
            {:wday => 1, :week => -1, :slug => "memorial-day", :name => "Memorial Day", :regions => [:ig7]}],
      6 => [{:wday => 0, :week => 1, :hide_date => true, :slug => "summer", :name => "Summer Events", :regions => [:ig7]},
            {:wday => 0, :week => 3, :slug => "fathers-day", :name => "Father's Day", :regions => [:ig7]}],
      7 => [{:mday => 4, :slug => "independence-day", :name => "Independence Day", :regions => [:ig7]},
            {:wday => 0, :week => 2, :hide_date => true, :slug => "vbs", :name => "VBS", :regions => [:ig7]}],
      8 => [{:wday => 0, :week => 2, :hide_date => true, :slug => "back-to-school", :name => "Back to School", :regions => [:ig7]},
            {:wday => 0, :week => 1, :hide_date => true, :slug => "fall", :name => "Fall Events", :regions => [:ig7]}],
      9 => [{:wday => 1, :week => 1, :slug => "labor-day", :name => "Labor Day", :regions => [:ig7]},
            {:wday => 3, :week => 4, :slug => "see-you-at-the-pole", :name => "See You at the Pole", :regions => [:ig7]}],
      10 => [{:wday => 0, :week => 2, :slug => "pastor-appreciation", :name => "Pastor Appreciation", :regions => [:ig7]},
            {:mday => 31, :slug => "halloween", :name => "Halloween", :regions => [:ig7]},
            {:mday => 31, :slug => "reformation-day", :name => "Reformation Day", :regions => [:ig7]}],
      11 => [{:wday => 0, :week => 1, :slug => "daylight-saving-ends", :name => "Daylight Saving Ends", :regions => [:ig7]},
            {:function => lambda { |year| Holidays.election_day(year) }, :function_id => "election_day(year)", :slug => "election-day", :name => "Election Day", :regions => [:ig7]},
            {:mday => 11, :slug => "veterans-day", :name => "Veteran's Day", :regions => [:ig7]},
            {:wday => 4, :week => 4, :slug => "thanksgiving", :name => "Thanksgiving", :regions => [:ig7]}],
      12 => [{:wday => 0, :week => 1, :hide_date => true, :slug => "winter", :name => "Winter Events", :regions => [:ig7]},
            {:mday => 25, :slug => "christmas", :name => "Christmas Day", :regions => [:ig7]}]
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

Holidays.merge_defs(Holidays::IG7.defined_regions, Holidays::IG7.holidays_by_month)
