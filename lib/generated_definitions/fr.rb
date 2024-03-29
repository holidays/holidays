# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: definitions/fr.yaml
  #
  # All the definitions are available at https://github.com/holidays/holidays
  module FR # :nodoc:
    def self.defined_regions
      [:fr_a, :fr_m, :fr]
    end

    def self.holidays_by_month
      {
                0 => [{:function => "easter(year)", :function_arguments => [:year], :function_modifier => -2, :name => "Vendredi saint", :regions => [:fr_a, :fr_m]},
            {:function => "easter(year)", :function_arguments => [:year], :type => :informal, :name => "Pâques", :regions => [:fr]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 1, :name => "Lundi de Pâques", :regions => [:fr]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 39, :name => "Ascension", :regions => [:fr]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 49, :name => "Pentecôte", :regions => [:fr]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 50, :type => :informal, :name => "Lundi de Pentecôte", :regions => [:fr]}],
      1 => [{:mday => 1, :name => "Jour de l'an", :regions => [:fr]}],
      5 => [{:mday => 1, :name => "Fête du travail", :regions => [:fr]},
            {:mday => 8, :name => "Victoire 1945", :regions => [:fr]}],
      7 => [{:mday => 14, :name => "Fête nationale", :regions => [:fr]}],
      8 => [{:mday => 15, :name => "Assomption", :regions => [:fr]}],
      11 => [{:mday => 1, :name => "Toussaint", :regions => [:fr]},
            {:mday => 11, :name => "Armistice 1918", :regions => [:fr]}],
      12 => [{:mday => 25, :name => "Noël", :regions => [:fr]},
            {:mday => 26, :name => "Saint-Étienne", :regions => [:fr_a, :fr_m]}]
      }
    end

    def self.custom_methods
      {
          
      }
    end
  end
end
