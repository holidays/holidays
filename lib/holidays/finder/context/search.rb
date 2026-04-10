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

                dates = if h[:function]
                  custom_holidays(year, month, h, regions)
                else
                  date = build_date(year, month, h, regions)
                  date ? [date] : []
                end

                dates.each do |d|
                  if observed_set?(options) && h[:observed]
                    d = build_observed_date(d, regions, h)
                  end
                  holidays << {:date => d, :name => h[:name], :regions => h[:regions]}
                end
              end
            end
          end

          holidays.sort_by.with_index do |h, i|
            direct = h[:regions].any? { |r| regions.include?(r) } ? 0 : 1
            [direct, i]
          end
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

        def build_date(year, month, h, queried_regions)
          current_month = month
          current_day = h[:mday] || @day_of_month_calculator.call(year, month, h[:week], h[:wday])

          # Silently skip bad mdays
          #TODO Should we be doing something different here? We have no concept of logging right now. Maybe we should add it?
          Date.civil(year, current_month, current_day) rescue nil
        end

        def custom_holidays(year, month, h, queried_regions)
          effective_regions = queried_regions & h[:regions]
          effective_regions = [queried_regions.first] if effective_regions.empty?

          effective_regions.each_with_object([]) do |region, dates|
            result = @custom_method_processor.call(
              { year: year, month: month, day: h[:mday], region: region },
              h[:function], h[:function_arguments], h[:function_modifier],
            )
            next if result.nil?
            date = Date.civil(year, result.month, result.mday) rescue nil
            dates << date if date
          end.uniq
        end

        def build_custom_method_input(year, month, day, queried_regions, holiday_regions = nil)
          # When the queried region is :any (or no holiday_regions are provided), fall back
          # to the holiday's own first region. Otherwise use the first queried region that
          # also appears in the holiday's region list so that region-specific function
          # implementations resolve correctly even when a holiday definition is shared across
          # multiple regions.
          effective_region = if holiday_regions.nil? || queried_regions.include?(:any)
            queried_regions.first
          else
            (queried_regions & holiday_regions).first || holiday_regions.first
          end

          {
            year: year,
            month: month,
            day: day,
            region: effective_region,
          }
        end

        def build_observed_date(date, regions, h)
          @custom_method_processor.call(
            build_custom_method_input(date.year, date.month, date.day, regions),
            h[:observed],
            [:date],
          )
        end
      end
    end
  end
end
