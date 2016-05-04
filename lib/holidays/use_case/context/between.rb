module Holidays
  module UseCase
    module Context
      class Between < ContextCommon
        def initialize(holidays_by_month_repo, day_of_month_calculator, custom_methods_repo, proc_result_cache_repo)
          @holidays_by_month_repo = holidays_by_month_repo
          @day_of_month_calculator = day_of_month_calculator
          @custom_methods_repo = custom_methods_repo
          @proc_result_cache_repo = proc_result_cache_repo
        end

        def call(start_date, end_date, dates_driver, regions, observed, informal)
          validate!(start_date, end_date, dates_driver, regions)

          holidays = []
          
          holidays = make_date_array(dates_driver, regions, observed, informal)

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

      end
    end
  end
end
