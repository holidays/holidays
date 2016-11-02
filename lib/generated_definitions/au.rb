# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: definitions/au.yaml
  #
  # To use the definitions in this file, load it right after you load the
  # Holiday gem:
  #
  #   require 'holidays'
  #   require 'generated_definitions/au'
  #
  # All the definitions are available at https://github.com/holidays/holidays
  module AU # :nodoc:
    def self.defined_regions
      [:au, :au_nsw, :au_vic, :au_qld, :au_nt, :au_act, :au_sa, :au_tas_south, :au_wa, :au_tas, :au_qld_cairns, :au_qld_brisbane, :au_tas_north, :au_vic_melbourne]
    end

    def self.holidays_by_month
      {
              0 => [{:function => "easter(year)", :function_arguments => [:year], :function_modifier => -2, :name => "Good Friday", :regions => [:au]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => -1, :name => "Easter Saturday", :regions => [:au_nsw, :au_vic, :au_qld, :au_nt, :au_act, :au_sa]},
            {:function => "easter(year)", :function_arguments => [:year], :name => "Easter Sunday", :regions => [:au_nsw, :au_vic]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 1, :name => "Easter Monday", :regions => [:au]}],
      1 => [{:mday => 1, :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "New Year's Day", :regions => [:au]},
            {:mday => 26, :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "Australia Day", :regions => [:au]}],
      2 => [{:wday => 1, :week => 2, :name => "Royal Hobart Regatta", :regions => [:au_tas_south]}],
      3 => [{:wday => 1, :week => 1, :name => "Labour Day", :regions => [:au_wa]},
            {:wday => 1, :week => 2, :name => "Eight Hours Day", :regions => [:au_tas]},
            {:wday => 1, :week => 2, :name => "Labour Day", :regions => [:au_vic]},
            {:function => "march_pub_hol_sa(year)", :function_arguments => [:year], :name => "March Public Holiday", :regions => [:au_sa]}],
      4 => [{:mday => 25, :name => "ANZAC Day", :regions => [:au]},
            {:mday => 25, :observed => "to_monday_if_sunday(date)", :observed_arguments => [:date], :name => "ANZAC Day", :regions => [:au_nsw, :au_vic, :au_qld, :au_nt, :au_act, :au_sa, :au_tas]},
            {:mday => 25, :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "ANZAC Day", :regions => [:au_wa]}],
      5 => [{:function => "qld_labour_day_may(year)", :function_arguments => [:year], :name => "Labour Day", :regions => [:au_qld]},
            {:wday => 1, :week => 1, :name => "May Day", :regions => [:au_nt]},
            {:function => "may_pub_hol_sa(year)", :function_arguments => [:year], :name => "May Public Holiday", :regions => [:au_sa]}],
      6 => [{:wday => 1, :week => 1, :name => "Foundation Day", :regions => [:au_wa]},
            {:wday => 1, :week => 2, :name => "Queen's Birthday", :regions => [:au_act, :au_nsw, :au_sa, :au_tas, :au_nt, :au_vic]},
            {:function => "qld_queens_birthday_june(year)", :function_arguments => [:year], :name => "Queen's Birthday", :regions => [:au_qld]},
            {:mday => 6, :type => :informal, :name => "Queensland Day", :regions => [:au_qld]}],
      7 => [{:wday => 5, :week => 3, :name => "Cairns Show", :regions => [:au_qld_cairns]}],
      8 => [{:wday => 3, :week => -3, :name => "Ekka", :regions => [:au_qld_brisbane]}],
      9 => [{:wday => 1, :week => -1, :name => "Queen's Birthday", :regions => [:au_wa]},
            {:wday => 1, :week => -1, :name => "Family & Community Day", :regions => [:au_act]}],
      10 => [{:function => "afl_grand_final(year)", :function_arguments => [:year], :name => "Friday before the AFL Grand Final", :regions => [:au_vic]},
            {:wday => 1, :week => 1, :name => "Labour Day", :regions => [:au_act, :au_nsw, :au_sa]},
            {:function => "qld_labour_day_october(year)", :function_arguments => [:year], :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "Labour Day", :regions => [:au_qld]},
            {:function => "qld_queens_bday_october(year)", :function_arguments => [:year], :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "Queen's Birthday", :regions => [:au_qld]},
            {:function => "hobart_show_day(year)", :function_arguments => [:year], :name => "Royal Hobart Show", :regions => [:au_tas_south]}],
      11 => [{:function => "g20_day_2014_only(year)", :function_arguments => [:year], :name => "G20 Day", :regions => [:au_qld_brisbane]},
            {:wday => 1, :week => 1, :name => "Recreation Day", :regions => [:au_tas_north]},
            {:function => "melbourne_cup_day_melbourne_only(year)", :function_arguments => [:year], :name => "Melbourne Cup Day", :regions => [:au_vic_melbourne]},
            {:function => "melbourne_cup_day_all_vic(year)", :function_arguments => [:year], :name => "Melbourne Cup Day", :regions => [:au_vic, :au_vic_melbourne]}],
      12 => [{:mday => 25, :observed => "to_tuesday_if_sunday_or_monday_if_saturday(date)", :observed_arguments => [:date], :name => "Christmas Day", :regions => [:au_qld, :au_nsw, :au_act, :au_tas, :au_wa]},
            {:mday => 25, :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "Christmas Day", :regions => [:au_sa]},
            {:function => "xmas_to_weekday_if_weekend(year)", :function_arguments => [:year], :name => "Christmas Day", :regions => [:au_vic, :au_nt]},
            {:mday => 26, :observed => "to_tuesday_if_sunday_or_monday_if_saturday(date)", :observed_arguments => [:date], :name => "Boxing Day", :regions => [:au_nsw, :au_vic, :au_qld, :au_act, :au_wa]},
            {:function => "to_weekday_if_boxing_weekend_from_year_or_to_tuesday_if_monday(year)", :function_arguments => [:year], :name => "Boxing Day", :regions => [:au_sa]},
            {:function => "to_weekday_if_boxing_weekend_from_year(year)", :function_arguments => [:year], :name => "Boxing Day", :regions => [:au_tas, :au_nt]}]
      }
    end

    def self.custom_methods
      {
        "melbourne_cup_day_melbourne_only(year)" => Proc.new { |year|
if year <= 2015
  Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 11, :first, :tuesday)
end
},

"melbourne_cup_day_all_vic(year)" => Proc.new { |year|
if year >= 2016
  Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 11, :first, :tuesday)
end
},

"afl_grand_final(year)" => Proc.new { |year|
case year
when 2015
  Date.civil(2015, 10, 2)
when 2016
  Date.civil(2017, 9, 30)
end
},

"qld_queens_bday_october(year)" => Proc.new { |year|
if year >= 2016
  Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 1, 1)
elsif year == 2012
  1
else
  nil
end
},

"qld_queens_birthday_june(year)" => Proc.new { |year|
if year <= 2015
  Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 6, 2, 1)
end
},

"qld_labour_day_may(year)" => Proc.new { |year|
if year < 2013 || year >= 2016
  Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 5, 1, 1)
end
},

"qld_labour_day_october(year)" => Proc.new { |year|
if year >= 2013 && year < 2016
  Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 1, 1)
end
},

"g20_day_2014_only(year)" => Proc.new { |year|
year == 2014 ? 14 : nil
},

"hobart_show_day(year)" => Proc.new { |year|
fourth_sat_in_oct = Date.civil(year, 10, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 4, :saturday))
fourth_sat_in_oct - 2 # the thursday before
},

"march_pub_hol_sa(year)" => Proc.new { |year|
if year < 2006
  nil
else
  Date.civil(year, 3, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 3, :second, :monday))
end
},

"may_pub_hol_sa(year)" => Proc.new { |year|
if year >= 2006
  nil
else
  Date.civil(year, 5, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 5, :third, :monday))
end
},


      }
    end
  end
end
