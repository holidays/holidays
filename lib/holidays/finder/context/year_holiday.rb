module Holidays
  module Finder
    module Context
      class YearHoliday
        def initialize(definition_search, dates_driver_builder, options_parser)
          @definition_search = definition_search
          @dates_driver_builder = dates_driver_builder
          @options_parser = options_parser
        end

        def call(from_date, options)
          validate!(from_date)

          regions, observed, informal = @options_parser.call(options)

          # The driver stops at to_date; the dates driver still adds January of
          # the next year as a border month. Searching a full 12 months from
          # from_date would make the next year a searched year rather than
          # border padding, so e.g. year_holidays for 2100 would need lunar
          # data for 2101.
          to_date = Date.civil(from_date.year, 12, 31)
          dates_driver = @dates_driver_builder.call(from_date, to_date)
          holidays = []
          ret_holidays = []
          opts = gather_options(observed, informal)

          ret_holidays = @definition_search.call(dates_driver, regions, opts)

          ret_holidays.each do |holiday|
            if holiday[:date] >= from_date && holiday[:date] <= to_date
              holidays << holiday
            end
          end

          holidays.sort_by { |a| a[:date] }
        end

        private

        def validate!(from_date)
          raise ArgumentError unless from_date && from_date.is_a?(Date)
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
