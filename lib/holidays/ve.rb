# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/ve.yaml
  #
  # To use the definitions in this file, load it right after you load the
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/ve'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module VE # :nodoc:
    def self.defined_regions
      [:ve]
    end

    def self.holidays_by_month
      {
              0 => [{:function => lambda { |year| Holidays.easter(year)-48 }, :function_id => "easter(year)-48", :name => "Lunes Carnaval", :regions => [:ve]},
            {:function => lambda { |year| Holidays.easter(year)-47 }, :function_id => "easter(year)-47", :name => "Martes Carnaval", :regions => [:ve]},
            {:function => lambda { |year| Holidays.easter(year)-3 }, :function_id => "easter(year)-3", :name => "Jueves Santo", :regions => [:ve]},
            {:function => lambda { |year| Holidays.easter(year)-2 }, :function_id => "easter(year)-2", :name => "Viernes Santo", :regions => [:ve]}],
      1 => [{:mday => 1, :name => "Año Nuevo", :regions => [:ve]}],
      4 => [{:mday => 19, :name => "Declaración Independencia", :regions => [:ve]}],
      5 => [{:mday => 1, :name => "Día del Trabajador", :regions => [:ve]}],
      6 => [{:mday => 24, :name => "Aniversario Batalla de Carabobo", :regions => [:ve]}],
      7 => [{:mday => 5, :name => "Día de la Independencia", :regions => [:ve]},
            {:mday => 24, :name => "Natalicio de Simón Bolívar", :regions => [:ve]}],
      10 => [{:mday => 12, :name => "Día de la Resistencia Indígena", :regions => [:ve]}],
      12 => [{:mday => 25, :name => "Día de Navidad", :regions => [:ve]}]
      }
    end
  end


end

defined_regions = Holidays::VE.defined_regions
holidays_by_month = Holidays::VE.holidays_by_month
Holidays.merge_defs(defined_regions, holidays_by_month)
