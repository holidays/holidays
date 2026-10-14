require 'date'

module Holidays
  module Definition
    module CustomMethods
      # cl custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/cl.yaml.
      module CL
        class << self
          def indigenous_peoples_day_cl(year)
            return Date.civil(2021, 6, 21) if year == 2021
            raise IndexError, 'Out of range' unless (2022..2099).cover?(year)

            day = 21.019 + 0.242194 * (year - 1980) - ((year - 1980) / 4).floor
            Date.civil(year, 6, day.floor)
          end

          def st_peter_st_paul_cl(year)
            date = Date.civil(year, 6, 29)
            if [2,3,4].include?(date.wday)
              date -= (date.wday - 1)
            elsif date.wday == 5
              date += 3
            end
            date
          end

          def columbus_day_cl(year)
            date = Date.civil(year, 10, 12)
            if [2,3,4].include?(date.wday)
              date -= (date.wday - 1)
            elsif date.wday == 5
              date += 3
            end
            date
          end

          def other_churches_day_cl(year)
            date = Date.civil(year, 10, 31)
            if date.wday == 2
              date -= 4
            elsif date.wday == 3
              date += 2
            end
            date
          end
        end
      end
    end
  end
end
