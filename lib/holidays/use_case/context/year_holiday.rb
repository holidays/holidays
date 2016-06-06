module Holidays
  module UseCase
    module Context
      class YearHoliday
        include ContextCommon

        def initialize(holidays_by_month_repo, day_of_month_calculator, custom_methods_repo, proc_result_cache_repo)
          @holidays_by_month_repo = holidays_by_month_repo
          @day_of_month_calculator = day_of_month_calculator
          @custom_methods_repo = custom_methods_repo
          @proc_result_cache_repo = proc_result_cache_repo
        end

        def call(from_date, to_date, dates_driver, regions, observed, informal)
          validate!(from_date, to_date, dates_driver, regions)
          holidays = []
          ret_holidays = []

          ret_holidays = make_date_array(dates_driver, regions, observed, informal)
          ret_holidays.each do |holiday|
            if holiday[:date] >= from_date && holiday[:date] <= to_date
              holidays << holiday
            end
          end

          holidays.sort{|a, b| a[:date] <=> b[:date] }
        end

        private

        attr_reader :holidays_by_month_repo,
                    :day_of_month_calculator,
                    :custom_methods_repo,
                    :proc_result_cache_repo

        def validate!(from_date, to_date, dates_driver, regions)
          raise ArgumentError unless from_date
          raise ArgumentError unless to_date

          raise ArgumentError if dates_driver.nil? || dates_driver.empty?

          dates_driver.each do |year, months|
            raise ArgumentError if months.nil? || months.empty?
          end

          raise ArgumentError if regions.nil? || regions.empty?
        end
      end
    end
  end
end
