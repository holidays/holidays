# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/lt.yaml
  #
  # To use the definitions in this file, load it right after you load the 
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/lt'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module LT # :nodoc:
    def self.defined_regions
      [:lt]
    end

    def self.holidays_by_month
      {
              0 => [{:function => lambda { |year| Holidays.easter(year) }, :function_id => "easter(year)", :name => "Šv. Velykos", :regions => [:lt]},
            {:function => lambda { |year| Holidays.easter(year)+1 }, :function_id => "easter(year)+1", :name => "Antroji Velykų diena", :regions => [:lt]}],
      1 => [{:mday => 1, :name => "Naujieji metai", :regions => [:lt]}],
      2 => [{:mday => 16, :name => "Valstybės atkūrimo diena", :regions => [:lt]}],
      3 => [{:mday => 11, :name => "Nepriklausomybės atkūrimo diena", :regions => [:lt]}],
      5 => [{:mday => 1, :name => "Darbininkų diena", :regions => [:lt]}],
      6 => [{:mday => 24, :name => "Joninės", :regions => [:lt]}],
      7 => [{:mday => 6, :name => "Valstybės diena", :regions => [:lt]}],
      8 => [{:mday => 15, :name => "Žolinė", :regions => [:lt]}],
      11 => [{:mday => 1, :name => "Visų šventųjų diena", :regions => [:lt]}],
      12 => [{:mday => 24, :name => "Šv. Kūčios", :regions => [:lt]},
            {:mday => 25, :name => "Šv. Kalėdos", :regions => [:lt]},
            {:mday => 26, :name => "Antroji Kalėdų diena", :regions => [:lt]}]
      }
    end
  end


end

Holidays.merge_defs(Holidays::LT.defined_regions, Holidays::LT.holidays_by_month)
