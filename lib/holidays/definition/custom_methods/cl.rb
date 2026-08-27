require 'date'

module Holidays
  module Definition
    module CustomMethods
      # cl custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/cl.yaml.
      module CL
        class << self
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
