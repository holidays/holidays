# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/nerc.yaml
  #
  # To use the definitions in this file, load it right after you load the 
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/nerc'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module NERC # :nodoc:
    def self.defined_regions
      [:nerc]
    end

    def self.holidays_by_month
      {
              1 => [{:mday => 1, :observed => lambda { |date| Holidays.to_monday_if_sunday(date) }, :observed_id => "to_monday_if_sunday", :name => "New Year's Day", :regions => [:nerc]}],
      5 => [{:wday => 1, :week => -1, :name => "Memorial Day", :regions => [:nerc]}],
      7 => [{:mday => 4, :observed => lambda { |date| Holidays.to_monday_if_sunday(date) }, :observed_id => "to_monday_if_sunday", :name => "Independence Day", :regions => [:nerc]}],
      9 => [{:wday => 1, :week => 1, :name => "Labor Day", :regions => [:nerc]}],
      11 => [{:wday => 4, :week => 4, :name => "Thanksgiving", :regions => [:nerc]}],
      12 => [{:mday => 25, :observed => lambda { |date| Holidays.to_monday_if_sunday(date) }, :observed_id => "to_monday_if_sunday", :name => "Christmas Day", :regions => [:nerc]}]
      }
    end
  end


end

Holidays.merge_defs(Holidays::NERC.defined_regions, Holidays::NERC.holidays_by_month)
