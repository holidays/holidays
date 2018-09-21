module Holidays
  module Finder
    module Context
      class Search
        def initialize(holidays_by_month_repo, custom_method_processor, day_of_month_calculator, rules)
          @holidays_by_month_repo = holidays_by_month_repo
          @custom_method_processor = custom_method_processor
          @day_of_month_calculator = day_of_month_calculator
          @rules = rules
        end

        def call(dates_driver, regions, options)
          validate!(dates_driver)

          holidays = []
          dates_driver.each do |year, months|
            months.each do |month|
              next unless hbm = @holidays_by_month_repo.find_by_month(month)
              hbm.each do |h|
                next if informal_type?(h[:type]) && !informal_set?(options)
                next unless @rules[:in_region].call(regions, h[:regions])

                if h[:year_ranges]
                  next unless @rules[:year_range].call(year, h[:year_ranges])
                end

                current_month = month
                current_day = h[:mday]

                if h[:function]
                  result = @custom_method_processor.call(
                    build_custom_method_input(year, current_month, current_day, h[:regions]),
                    h[:function], h[:function_arguments], h[:function_modifier],
                  )

                  #FIXME The result should always be present, see https://github.com/holidays/holidays/issues/204 for more information
                  if result
                    current_month = result.month
                    current_day = result.mday
                  else
                    current_month = nil
                    current_day = nil
                  end
                else
                  current_day = h[:mday] || @day_of_month_calculator.call(year, current_month, h[:week], h[:wday])
                end

                # Silently skip bad mdays
                #TODO Should we be doing something different here? We have no concept of logging right now. Maybe we should add it?
                begin
                  date = Date.civil(year, current_month, current_day)
                rescue; next; end

                if observed_set?(options) && h[:observed]
                  date = @custom_method_processor.call(
                    build_custom_method_input(date.year, date.month, date.day, regions),
                    h[:observed],
                    [:date],
                  )
                end

                holidays << {:date => date, :name => h[:name], :regions => h[:regions]}
              end
            end
          end

          holidays
        end

        private

        def validate!(dates_driver)
          #FIXME This should give some kind of error message that indicates the
          #      problem.
          raise ArgumentError if dates_driver.nil? || dates_driver.empty?

          dates_driver.each do |year, months|
            months.each do |month|
              raise ArgumentError unless month >= 0 && month <= 12
            end
          end
        end

        def informal_type?(type)
          type && [:informal, 'informal'].include?(type)
        end

        def informal_set?(options)
          options && options.include?(:informal) == true
        end

        def observed_set?(options)
          options && options.include?(:observed) == true
        end

        def build_custom_method_input(year, month, day, regions)
          {
            year: year,
            month: month,
            day: day,
            region: regions.first, #FIXME This isn't ideal but will work for our current use case...
          }
        end
      end
    end
  end
end
