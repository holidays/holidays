require 'holidays/finder/context/between'
require 'holidays/finder/context/dates_driver_builder'
require 'holidays/finder/context/next_holiday'
require 'holidays/finder/context/year_holiday'
require 'holidays/finder/context/search'
require 'holidays/finder/rules/in_region'
require 'holidays/finder/rules/year_range'

module Holidays
  module FinderFactory
    class << self
      def search
        Finder::Context::Search.new(
          DefinitionFactory.holidays_by_month_repository,
          DefinitionFactory.function_processor,
          DateCalculatorFactory.day_of_month_calculator,
          rules,
        )
      end

      def between
        Finder::Context::Between.new(
          search,
          dates_driver_builder,
        )
      end

      def next_holiday
        Finder::Context::NextHoliday.new(
          search,
          dates_driver_builder,
        )
      end

      def year_holiday
        Finder::Context::YearHoliday.new(
          search,
          dates_driver_builder,
        )
      end

      private

      def dates_driver_builder
        Finder::Context::DatesDriverBuilder.new
      end

      def rules
        {
          :in_region => Finder::Rules::InRegion,
          :year_range => Finder::Rules::YearRange,
        }
      end
    end
  end
end
