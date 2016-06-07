module Holidays
  module UseCase
    module Context
      class Between
        def initialize(definition_search)
          @definition_search = definition_search
        end

        def call(start_date, end_date, dates_driver, regions, observed, informal)
          validate!(start_date, end_date, dates_driver, regions)

          holidays = []
          opts = gather_options(observed, informal)

          holidays = @definition_search.call(dates_driver, regions, opts)
          holidays = holidays.select{|holiday|holiday[:date].between?(start_date, end_date)}
          holidays.sort{|a, b| a[:date] <=> b[:date] }
        end

        private

        def validate!(start_date, end_date, dates_driver, regions)
          raise ArgumentError unless start_date
          raise ArgumentError unless end_date

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
