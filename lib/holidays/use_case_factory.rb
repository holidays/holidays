require 'holidays/use_case/context/between'

module Holidays
  class UseCaseFactory
    class << self
      def between
        UseCase::Context::Between.new(
          DefinitionFactory.cache_repository,
          OptionFactory.parse_options,
          DefinitionFactory.holidays_by_month_repository,
          DateCalculatorFactory.day_of_month_calculator,
          DefinitionFactory.proc_cache_repository,
        )
      end
    end
  end
end
