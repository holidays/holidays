require 'holidays/date_calculator/easter'
require 'holidays/date_calculator/weekend_modifier'
require 'holidays/date_calculator/day_of_month'
require 'holidays/date_calculator/lunisolar'

module Holidays
  module DateCalculatorFactory
    module Easter
      module Gregorian
        class << self
          def easter_calculator
            DateCalculator::Easter::Gregorian.new
          end
        end
      end

      module Julian
        class << self
          def easter_calculator
            DateCalculator::Easter::Julian.new
          end
        end
      end
    end

    class << self
      def weekend_modifier
        DateCalculator::WeekendModifier.new
      end

      def day_of_month_calculator
        DateCalculator::DayOfMonth.new
      end
    end
  end
end
