require 'date'

module Holidays
  module Definition
    module CustomMethods
      # au custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/au.yaml.
      module AU
        class << self
          def afl_grand_final(year)
            case year
            when 2015
              Date.civil(2015, 10, 2)
            when 2016
              Date.civil(2016, 9, 30)
            when 2017
              Date.civil(2017, 9, 29)
            when 2020
              Date.civil(2020, 10, 23)
            when 2022
              Date.civil(2022, 9, 23)
            else
              # Friday before AFL Grand Final typically falls on the last Friday in September
              # Override when falls on a different date
              last_day = Date.civil(year, 9, -1)
              last_friday = last_day - ((last_day.wday - 5) % 7)
              last_friday
            end
          end

          def qld_queens_bday_october(year)
            Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 1, 1)
          end

          def qld_kings_bday_october(year)
            Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 1, 1)
          end

          def qld_queens_birthday_june(year)
            Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 6, 2, 1)
          end

          def qld_labour_day_may(year)
            Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 5, 1, 1)
          end

          def qld_labour_day_october(year)
            Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 1, 1)
          end

          def hobart_show_day(year)
            fourth_sat_in_oct = Date.civil(year, 10, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 4, :saturday))
            fourth_sat_in_oct - 2 # the thursday before
          end

          def march_pub_hol_sa(year)
            Date.civil(year, 3, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 3, :second, :monday))
          end

          def may_pub_hol_sa(year)
            Date.civil(year, 5, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 5, :third, :monday))
          end

          def qld_brisbane_ekka_holiday(year)
            first_friday = Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 8, :first, :friday)

            if first_friday < 5
              second_friday = Date.civil(year, 8, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 8, :second, :friday))
              second_friday + 5 # The next Wednesday
            else
              Date.civil(year, 8, first_friday) + 5
            end
          end

          def to_nearest_monday_after(date)
            case date.wday
            when 6
              date += 2
            when 5
              date += 3
            when 4
              date += 4
            when 3
              date += 5
            when 2
              date += 6
            when 0
              date += 1
            end
            date
          end
        end
      end
    end
  end
end
