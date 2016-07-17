module Holidays
  module UseCase
    module Context
      class YearHoliday
        def initialize(definition_search)
          @definition_search = definition_search
        end

        def call(from_date, dates_driver, regions, observed, informal)
          validate!(from_date, dates_driver, regions)

          to_date = Date.civil(from_date.year, 12, 31)
          holidays = []
          ret_holidays = []
          opts = gather_options(observed, informal)

          ret_holidays = @definition_search.call(dates_driver, regions, opts)

          ret_holidays.each do |holiday|
            if holiday[:date] >= from_date && holiday[:date] <= to_date
              holidays << holiday
            end
          end

          holidays.sort{|a, b| a[:date] <=> b[:date] }
        end

        private

        def validate!(from_date, dates_driver, regions)
          raise ArgumentError unless from_date && from_date.is_a?(Date)
          raise ArgumentError if dates_driver.nil? || dates_driver.empty?

          dates_driver.each do |year, months|
            raise ArgumentError if months.nil? || months.empty?
          end

          raise ArgumentError if regions.nil? || regions.empty?
        end

        def gather_options(observed, informal)
          opts = []

          opts << :observed if observed == true
          opts << :informal if informal == true

          opts
        end
      end
    end
  end
end
