require 'holidays/use_case/context/between'
require 'holidays/use_case/context/next_holiday'
require 'holidays/use_case/context/dates_driver_builder'
require 'holidays/use_case/context/year_holiday'
require 'holidays/finder_factory'

module Holidays
  class UseCaseFactory
    class << self
      def between
        UseCase::Context::Between.new(
          FinderFactory.search,
        )
      end
      def next_holiday
        UseCase::Context::NextHoliday.new(
          FinderFactory.search,
        )
      end

      def year_holiday
        UseCase::Context::YearHoliday.new(
          FinderFactory.search,
        )
      end

      def dates_driver_builder
        UseCase::Context::DatesDriverBuilder.new
      end
    end
  end
end
