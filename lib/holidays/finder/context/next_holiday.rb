module Holidays
  module Finder
    module Context
      class NextHoliday
        def initialize(definition_search, dates_driver_builder)
          @definition_search = definition_search
          @dates_driver_builder = dates_driver_builder
        end

        def call(holidays_count, from_date, regions, observed, informal)
          validate!(holidays_count, from_date, regions)

          holidays = []
          ret_holidays = []
          opts = gather_options(observed, informal)

          # This could be smarter but I don't have any evidence that just checking for
          # the next 12 months will cause us issues. If it does we can implement something
          # smarter here to check in smaller increments.
          dates_driver = @dates_driver_builder.call(from_date, from_date >> 12)

          ret_holidays = @definition_search.call(dates_driver, regions, opts)

          ret_holidays.sort{|a, b| a[:date] <=> b[:date] }.each do |holiday|
            if holiday[:date] >= from_date
              holidays << holiday
              holidays_count -= 1
              break if holidays_count == 0
            end
          end

          holidays.sort{|a, b| a[:date] <=> b[:date] }
        end

        private

        def validate!(holidays_count, from_date, regions)
          raise ArgumentError unless holidays_count
          raise ArgumentError if holidays_count <= 0
          raise ArgumentError unless from_date
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
