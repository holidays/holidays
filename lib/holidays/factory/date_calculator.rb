require 'holidays/date_calculator/easter'
require 'holidays/date_calculator/weekend_modifier'
require 'holidays/date_calculator/day_of_month'

module Holidays
  module Factory
    module DateCalculator
      module Easter
        module Gregorian
          class << self
            def easter_calculator
              Holidays::DateCalculator::Easter::Gregorian.new
            end
          end
        end

        module Julian
          class << self
            def easter_calculator
              Holidays::DateCalculator::Easter::Julian.new
            end
          end
        end
      end

      class << self
        def weekend_modifier
          Holidays::DateCalculator::WeekendModifier.new
        end

        def day_of_month_calculator
          Holidays::DateCalculator::DayOfMonth.new
        end
      end
    end
  end
end
