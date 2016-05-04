module Holidays
  module UseCase
    module Context
      class NextHoliday < ContextCommon

        def call(holidays_count, from_date, dates_driver, regions, observed, informal)
          validate!(holidays_count, from_date, dates_driver, regions)
          holidays = []
          ret_holidays = []
          
          ret_holidays = make_date_array(dates_driver, regions, observed, informal)
          ret_holidays.each do |holiday|
            if holiday[:date] >= from_date
              holidays << holiday
              holidays_count -= 1
              break if holidays_count == 0
            end              
          end
          
          holidays.sort{|a, b| a[:date] <=> b[:date] }
        end

        private

        def validate!(holidays_count, from_date, dates_driver, regions)
          raise ArgumentError unless holidays_count
          raise ArgumentError if holidays_count <= 0
          raise ArgumentError unless from_date

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
