require 'holidays/date_calculator/easter'
require 'holidays/date_calculator/weekend_modifier'

module Holidays
  module DateCalculator
    class << self
      def calculate_easter_for(year)
        easter_calculator.calculate_easter_for(year)
      end

      def calculate_orthodox_easter_for(year)
        easter_calculator.calculate_orthodox_easter_for(year)
      end

      def to_weekday_if_weekend(date)
        weekend_modifier.to_weekday_if_weekend(date)
      end

      def to_weekday_if_boxing_weekend(date)
        weekend_modifier.to_weekday_if_boxing_weekend(date)
      end

      def to_monday_if_weekend(date)
        weekend_modifier.to_monday_if_weekend(date)
      end

      def to_monday_if_sunday(date)
        weekend_modifier.to_monday_if_sunday(date)
      end

      private

      def easter_calculator
        DateCalculator::Easter.new
      end

      def weekend_modifier
        DateCalculator::WeekendModifier.new
      end
    end
  end
end
