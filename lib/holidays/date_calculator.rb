require 'holidays/date_calculator/easter'
require 'holidays/date_calculator/weekend_modifier'
require 'holidays/date_calculator/day_of_month'

module Holidays
  module DateCalculator #TODO This should be renamed with 'Factory' for clarity
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

      def day_of_month(year, month, week, day)
        day_of_month_calculator.call(year, month, week, day)
      end

      private

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
