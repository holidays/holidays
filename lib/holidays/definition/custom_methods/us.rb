require 'date'

module Holidays
  module Definition
    module CustomMethods
      # us custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/us.yaml.
      module US
        class << self
          def christmas_eve_holiday(date)
            beginning_of_month = Date.civil(date.year, date.month, 1)
            (date.saturday? || date.sunday?) ? date.downto(beginning_of_month).find {|d| d if d.wday == 5} : date
          end

          def rosh_hashanah(year)
            rosh_hashanah_dates = {
                '2014' => Date.civil(2014, 9, 25),
                '2015' => Date.civil(2015, 9, 14),
                '2016' => Date.civil(2016, 10, 3),
                '2017' => Date.civil(2017, 9, 21),
                '2018' => Date.civil(2018, 9, 10),
                '2019' => Date.civil(2019, 9, 30),
                '2020' => Date.civil(2020, 9, 19)
            }
            rosh_hashanah_dates[year.to_s]
          end

          def yom_kippur(year)
            yom_kippur_dates = {
                '2014' => Date.civil(2014, 10, 4),
                '2015' => Date.civil(2015, 9, 23),
                '2016' => Date.civil(2016, 10, 12),
                '2017' => Date.civil(2017, 9, 30),
                '2018' => Date.civil(2018, 9, 19),
                '2019' => Date.civil(2019, 10, 9),
                '2020' => Date.civil(2020, 9, 28)
            }
            yom_kippur_dates[year.to_s]
          end

          def georgia_state_holiday(year, month)
            beginning_of_month = Date.civil(year, month, 1)
            state_holiday = Date.civil(year, month, 26)
            state_holiday.downto(beginning_of_month).find {|date| date if date.wday == 1 }
          end

          def lee_jackson_day(year, month)
            day_of_holiday = Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, month, 3, 1)
            beginning_of_month = Date.civil(year, month, 1)
            king_day = Date.civil(year, month, day_of_holiday)
            king_day.downto(beginning_of_month).find {|date| date if date.wday == 5 }
          end

          def juneteenth_national_independence_day(region, date)
            if region == :us_ut
              case date.wday
              when 1
                date
              when 2,3,4,5
                date - (date.wday - 1)
              when 6
                date + 2
              when 0
                date + 1
              end
            elsif date.wday == 0
              date + 1
            elsif date.wday == 6
              date - 1
            else
              date
            end
          end

          def election_day(year)
            Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 11, 1, 1) + 1
          end

          def even_year_election_day(year)
            if year % 2 == 0
              Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 11, 1, 1) + 1
            end
          end

          def us_inauguration_day(year)
            year % 4 == 1 ? 20 : nil
          end
        end
      end
    end
  end
end
