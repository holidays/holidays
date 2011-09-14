# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holiday gem.
  #
  # Definitions loaded: data/el.yaml
  #
  # To use the definitions in this file, load them right after you load the 
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'holidays/el'
  #
  # More definitions are available at http://code.dunae.ca/holidays.
  module EL # :nodoc:
    DEFINED_REGIONS = [:el]

    HOLIDAYS_BY_MONTH = {
      0 => [{:function => lambda { |year| Holidays.orthodox_easter(year)-2 }, :function_id => "orthodox_easter(year)-2", :name => "Μεγάλη Παρασκευή", :regions => [:el]},
            {:function => lambda { |year| Holidays.orthodox_easter(year)-1 }, :function_id => "orthodox_easter(year)-1", :name => "Μεγάλο Σάββατο", :regions => [:el]},
            {:function => lambda { |year| Holidays.orthodox_easter(year) }, :function_id => "orthodox_easter(year)", :name => "Κυριακή του Πάσχα", :regions => [:el]},
            {:function => lambda { |year| Holidays.orthodox_easter(year)+1 }, :function_id => "orthodox_easter(year)+1", :name => "Δευτέρα του Πάσχα", :regions => [:el]},
            {:function => lambda { |year| Holidays.orthodox_easter(year)-48 }, :function_id => "orthodox_easter(year)-48", :name => "Καθαρά Δευτέρα", :regions => [:el]},
            {:function => lambda { |year| Holidays.orthodox_easter(year)+50 }, :function_id => "orthodox_easter(year)+50", :name => "Αγίου Πνεύματος", :regions => [:el]}],
      1 => [{:mday => 1, :name => "Πρωτοχρονιά", :regions => [:el]},
            {:mday => 6, :name => "Θεοφάνεια", :regions => [:el]}],
      3 => [{:mday => 25, :name => "Επέτειος της Επανάστασης του 1821", :regions => [:el]}],
      5 => [{:mday => 1, :name => "Πρωτομαγιά", :regions => [:el]}],
      8 => [{:mday => 15, :name => "Κοίμηση της Θεοτόκου", :regions => [:el]}],
      10 => [{:mday => 28, :name => "Επέτειος του Όχι", :regions => [:el]}],
      12 => [{:mday => 25, :name => "Χριστούγεννα", :regions => [:el]},
            {:mday => 26, :name => "Δεύτερη ημέρα των Χριστουγέννων", :regions => [:el]}]
    }
  end


end

Holidays.merge_defs(Holidays::EL::DEFINED_REGIONS, Holidays::EL::HOLIDAYS_BY_MONTH)