module Holidays
  module Finder
    module Context
      class NextHoliday
        # Holidays are searched one 12 month window at a time. The search widens until
        # enough holidays are found or this many years have been searched, which stops
        # a region with no upcoming holidays from being searched forever.
        MAX_YEARS = 50

        def initialize(definition_search, dates_driver_builder, options_parser)
          @definition_search = definition_search
          @dates_driver_builder = dates_driver_builder
          @options_parser = options_parser
        end

        def call(holidays_count, from_date, options)
          validate!(holidays_count, from_date)

          regions, observed, informal = @options_parser.call(options)
          opts = gather_options(observed, informal)

          holidays = []

          1.upto(MAX_YEARS) do |year|
            holidays.concat(search_window(from_date, year, regions, opts))
            break if holidays.size >= holidays_count
          end

          holidays.first(holidays_count)
        end

        private

        # Windows are contiguous: each starts the day after the previous one ended. The
        # search only looks at the months around a window (plus month 0, which covers the
        # whole year), so dates past the window end are incomplete. They are discarded here
        # and found by the next window instead.
        def search_window(from_date, year, regions, opts)
          window_start = year == 1 ? from_date : (from_date >> 12 * (year - 1)) + 1
          window_end = from_date >> 12 * year

          dates_driver = @dates_driver_builder.call(window_start, window_end)

          @definition_search
            .call(dates_driver, regions, opts)
            .select { |holiday| (window_start..window_end).cover?(holiday[:date]) }
            .sort_by { |holiday| holiday[:date] }
        end

        def validate!(holidays_count, from_date)
          raise ArgumentError unless holidays_count
          raise ArgumentError if holidays_count <= 0
          raise ArgumentError unless from_date
        end

        def gather_options(observed, informal)
          opts = []

          opts << :observed if observed
          opts << :informal if informal

          opts
        end
      end
    end
  end
end
