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

      private

      def rules
        {
          :in_region => Finder::Rules::InRegion,
          :year_range => Finder::Rules::YearRange,
        }
      end
    end
  end
end
