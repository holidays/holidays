# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: data/pt.yaml
  #
  # To use the definitions in this file, load it right after you load the
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'generated_definitions/pt'
  #
  # All the definitions are available at https://github.com/alexdunae/holidays
  module PT # :nodoc:
    def self.defined_regions
      [:pt]
    end

    def self.holidays_by_month
      {
              0 => [{:function => lambda { |year| Holidays.easter(year)-47 }, :function_id => "easter(year)-47", :type => :informal, :name => "Carnaval", :regions => [:pt]},
            {:function => lambda { |year| Holidays.easter(year)-2 }, :function_id => "easter(year)-2", :name => "Sexta-feira Santa", :regions => [:pt]},
            {:function => lambda { |year| Holidays.easter(year) }, :function_id => "easter(year)", :name => "Páscoa", :regions => [:pt]}],
      1 => [{:mday => 1, :name => "Ano Novo", :regions => [:pt]}],
      4 => [{:mday => 25, :name => "Dia da Liberdade", :regions => [:pt]}],
      5 => [{:mday => 1, :name => "Dia do Trabalhador", :regions => [:pt]}],
      6 => [{:mday => 10, :name => "Dia de Portugal", :regions => [:pt]}],
      8 => [{:mday => 15, :name => "Assunção de Nossa Senhora", :regions => [:pt]}],
      12 => [{:mday => 8, :name => "Imaculada Conceição", :regions => [:pt]},
            {:mday => 25, :name => "Natal", :regions => [:pt]}]
      }
    end
  end


end

Holidays.merge_defs(Holidays::PT.defined_regions, Holidays::PT.holidays_by_month)