require 'date'

module Holidays
  module Definition
    module CustomMethods
      # jp custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/jp.yaml.
      module JP
        class << self
          def jp_health_sports_day_substitute(year)
            Holidays::Factory::Definition.custom_methods_repository.find("jp_substitute_holiday(year, month, day)").call(year, 10, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 10, 2, 1))
          end

          def jp_vernal_equinox_day(year)
            day =
              case year
              when 1851..1899
                19.8277
              when 1900..1979
                20.8357
              when 1980..2099
                20.8431
              when 2100..2150
                21.8510
              else
                raise IndexError.new("Out of range")
              end
            day += 0.242194 * (year - 1980) - ((year - 1980)/4).floor
            day = day.floor
            Date.civil(year, 3, day)
          end

          def jp_vernal_equinox_day_substitute(year)
            date = Holidays::Factory::Definition.custom_methods_repository.find("jp_vernal_equinox_day(year)").call(year)
            Holidays::Factory::Definition.custom_methods_repository.find("jp_substitute_holiday(year, month, day)").call(year, date.month, date.mday)
          end

          def jp_marine_day_substitute(year)
            Holidays::Factory::Definition.custom_methods_repository.find("jp_substitute_holiday(year, month, day)").call(year, 7, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 7, 3, 1))
          end

          def jp_national_culture_day(year)
            day =
              case year
              when 1851..1899
                22.2588
              when 1900..1979
                23.2588
              when 1980..2099
                23.2488
              when 2100..2150
                24.2488
              else
                raise IndexError.new("Out of range")
              end
            day += 0.242194 * (year - 1980) - ((year - 1980)/4).floor
            day = day.floor
            Date.civil(year, 9, day)
          end

          def jp_national_culture_day_substitute(year)
            date = Holidays::Factory::Definition.custom_methods_repository.find("jp_national_culture_day(year)").call(year)
            Holidays::Factory::Definition.custom_methods_repository.find("jp_substitute_holiday(year, month, day)").call(year, date.month, date.mday)
          end

          def jp_citizens_holiday(year)
            ncd = Holidays::Factory::Definition.custom_methods_repository.find("jp_national_culture_day(year)").call(year)
            if ncd.wday == 3
              ncd - 1
            else
              nil
            end
          end

          def jp_mountain_holiday(year)
            Date.civil(year, 8, 11)
          end

          def jp_mountain_holiday_substitute(year)
            date = Holidays::Factory::Definition.custom_methods_repository.find("jp_mountain_holiday(year)").call(year)
            Holidays::Factory::Definition.custom_methods_repository.find("jp_substitute_holiday(year, month, day)").call(year, date.month, date.mday)
          end

          def jp_respect_for_aged_holiday_substitute(year)
            Holidays::Factory::Definition.custom_methods_repository.find("jp_substitute_holiday(year, month, day)").call(year, 9, Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 9, 3, 1))
          end

          def jp_substitute_holiday(year, month, day)
            date = Date.civil(year, month, day)
            date.wday == 0 ? (Holidays::Factory::Definition.custom_methods_repository.find("jp_next_weekday(date)").call(date+1)) : nil
          end

          def jp_next_weekday(date)
            # This suuuucks. I have no idea how to make this not reach into our interal ruby API to do this.
            # I'm punting, I'll come back to this.
            is_holiday = Holidays::JP.holidays_by_month[date.month].any? do |holiday|
              next false unless holiday[:mday] == date.day
              next true unless holiday[:year_ranges]
              Holidays::Finder::Rules::YearRange.call(date.year, holiday[:year_ranges])
            end
            date.wday == 0 || is_holiday ? (Holidays::Factory::Definition.custom_methods_repository.find("jp_next_weekday(date)").call(date+1)) : date
          end
        end
      end
    end
  end
end
