# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/ice_uk.yaml
  #
  # To use the definitions in this file, load it right after you load the
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/ice_uk'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module ICE_UK # :nodoc:
    def self.defined_regions
      [:ice_uk]
    end

    def self.holidays_by_month
      {
              0 => [{:function => lambda { |year| Holidays.easter(year)-2 }, :function_id => "easter(year)-2", :name => "Good Friday", :regions => [:ice_uk]},
            {:function => lambda { |year| Holidays.easter(year) }, :function_id => "easter(year)", :name => "Easter Sunday", :regions => [:ice_uk]},
            {:function => lambda { |year| Holidays.easter(year)+1 }, :function_id => "easter(year)+1", :name => "Easter Monday", :regions => [:ice_uk]}],
      1 => [{:mday => 1, :observed => lambda { |date| Holidays.to_monday_if_weekend(date) }, :observed_id => "to_monday_if_weekend", :name => "New Year's Day", :regions => [:ice_uk]}],
      5 => [{:wday => 1, :week => 1, :name => "May Day", :regions => [:ice_uk]},
            {:wday => 1, :week => -1, :name => "Bank Holiday", :regions => [:ice_uk]}],
      8 => [{:wday => 1, :week => -1, :name => "Bank Holiday", :regions => [:ice_uk]}],
      12 => [{:mday => 24, :name => "Day Before Christmas Day", :regions => [:ice_uk]},
            {:mday => 25, :observed => lambda { |date| Holidays.to_monday_if_weekend(date) }, :observed_id => "to_monday_if_weekend", :name => "Christmas Day", :regions => [:ice_uk]},
            {:mday => 26, :observed => lambda { |date| Holidays.to_weekday_if_boxing_weekend(date) }, :observed_id => "to_weekday_if_boxing_weekend", :name => "Boxing Day", :regions => [:ice_uk]},
            {:mday => 31, :name => "Day Before New Year's Day", :regions => [:ice_uk]}]
      }
    end
  end


end

Holidays.merge_defs(Holidays::ICE_UK.defined_regions, Holidays::ICE_UK.holidays_by_month)
