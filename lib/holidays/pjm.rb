# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/pjm.yaml
  #
  # To use the definitions in this file, load it right after you load the
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/pjm'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module PJM # :nodoc:
    def self.defined_regions
      [:pjm]
    end

    def self.holidays_by_month
      {
              1 => [{:mday => 1, :observed => lambda { |date| Holidays.to_monday_if_sunday_to_friday_if_saturday(date) }, :observed_id => "to_monday_if_sunday_to_friday_if_saturday", :name => "New Year's Day", :regions => [:pjm]},
            {:wday => 1, :week => 3, :name => "Martin Luther King, Jr. Day", :regions => [:pjm]}],
      2 => [{:wday => 1, :week => 3, :name => "Presidents' Day", :regions => [:pjm]}],
      5 => [{:wday => 1, :week => -1, :name => "Memorial Day", :regions => [:pjm]}],
      7 => [{:mday => 4, :observed => lambda { |date| Holidays.to_monday_if_sunday_to_friday_if_saturday(date) }, :observed_id => "to_monday_if_sunday_to_friday_if_saturday", :name => "Independence Day", :regions => [:pjm]}],
      9 => [{:wday => 1, :week => 1, :name => "Labor Day", :regions => [:pjm]}],
      11 => [{:wday => 4, :week => 4, :name => "Thanksgiving", :regions => [:pjm]},
            {:wday => 5, :week => 4, :name => "Day after Thanksgiving", :regions => [:pjm]}],
      12 => [{:mday => 25, :observed => lambda { |date| Holidays.to_monday_if_sunday_to_friday_if_saturday(date) }, :observed_id => "to_monday_if_sunday_to_friday_if_saturday", :name => "Christmas Day", :regions => [:pjm]}]
      }
    end
  end


end

defined_regions = Holidays::PJM.defined_regions
holidays_by_month = Holidays::PJM.holidays_by_month
Holidays.merge_defs(defined_regions, holidays_by_month)
