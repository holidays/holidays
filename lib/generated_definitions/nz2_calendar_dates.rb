# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: definitions/nz2_calendar_dates.yaml
  #
  # All the definitions are available at https://github.com/holidays/holidays
  module NZ2_CALENDAR_DATES # :nodoc:
    def self.defined_regions
      [:nz2_calendar_dates]
    end

    def self.holidays_by_month
      {
              0 => [{:function => "easter(year)", :function_arguments => [:year], :function_modifier => -2, :name => "Good Friday", :regions => [:nz2_calendar_dates]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 1, :name => "Easter Monday", :regions => [:nz2_calendar_dates]}],
      1 => [{:mday => 1, :name => "New Year's Day", :regions => [:nz2_calendar_dates]},
            {:mday => 2, :name => "Day after New Year's Day", :regions => [:nz2_calendar_dates]}],
      2 => [{:mday => 6, :name => "Waitangi Day", :regions => [:nz2_calendar_dates]}],
      4 => [{:mday => 25, :name => "ANZAC Day", :regions => [:nz2_calendar_dates]}],
      6 => [{:wday => 1, :week => 1, :name => "Queen's Birthday", :regions => [:nz2_calendar_dates]},
            {:function => "matariki_holiday(year)", :function_arguments => [:year], :name => "Matariki Holiday", :regions => [:nz2_calendar_dates]}],
      10 => [{:wday => 1, :week => 4, :name => "Labour Day", :regions => [:nz2_calendar_dates]}],
      12 => [{:mday => 25, :name => "Christmas Day", :regions => [:nz2_calendar_dates]},
            {:mday => 26, :name => "Boxing Day", :regions => [:nz2_calendar_dates]}]
      }
    end

    def self.custom_methods
      {
        "matariki_holiday(year)" => Proc.new { |year|
case year
when 2022
  Date.civil(2022, 6, 24)
when 2023
  Date.civil(2023, 7, 14)
when 2024
  Date.civil(2024, 6, 28)
when 2025
  Date.civil(2025, 6, 20)
when 2026
  Date.civil(2026, 7, 10)
when 2027
  Date.civil(2027, 6, 25)
when 2028
  Date.civil(2028, 7, 14)
when 2029
  Date.civil(2029, 7, 6)
when 2030
  Date.civil(2030, 6, 21)
when 2031
  Date.civil(2031, 7, 11)
when 2032
  Date.civil(2032, 7, 2)
when 2033
  Date.civil(2033, 6, 24)
when 2034
  Date.civil(2034, 7, 7)
when 2035
  Date.civil(2035, 6, 29)
when 2036
  Date.civil(2036, 7, 21)
when 2037
  Date.civil(2037, 7, 10)
when 2038
  Date.civil(2038, 6, 25)
when 2039
  Date.civil(2039, 7, 15)
when 2040
  Date.civil(2040, 7, 6)
when 2041
  Date.civil(2041, 7, 19)
when 2042
  Date.civil(2042, 7, 11)
when 2043
  Date.civil(2043, 7, 3)
when 2044
  Date.civil(2044, 6, 24)
when 2045
  Date.civil(2045, 7, 7)
when 2046
  Date.civil(2046, 6, 29)
when 2047
  Date.civil(2047, 7, 19)
when 2048
  Date.civil(2048, 7, 3)
when 2049
  Date.civil(2049, 6, 25)
when 2050
  Date.civil(2050, 7, 15)
when 2051
  Date.civil(2051, 6, 30)
when 2052
  Date.civil(2052, 6, 25)
end
},


      }
    end
  end
end
