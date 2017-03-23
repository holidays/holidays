require 'holidays/use_case/context/between'
require 'holidays/use_case/context/dates_driver_builder'

module Holidays
  class UseCaseFactory
    class << self
      def between
        UseCase::Context::Between.new(
          DefinitionFactory.holidays_by_month_repository,
          DateCalculatorFactory.day_of_month_calculator,
          DefinitionFactory.proc_cache_repository
        )
      end

      def dates_driver_builder
        UseCase::Context::DatesDriverBuilder.new
      end
    end
  end
end
