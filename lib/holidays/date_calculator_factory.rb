require 'holidays/date_calculator/easter'
require 'holidays/date_calculator/weekend_modifier'
require 'holidays/date_calculator/day_of_month'

module Holidays
  module DateCalculatorFactory
    class << self
      def easter_calculator
        DateCalculator::Easter.new
      end

      def weekend_modifier
        DateCalculator::WeekendModifier.new
      end

      def day_of_month_calculator
        DateCalculator::DayOfMonth.new
      end
    end
  end
end
