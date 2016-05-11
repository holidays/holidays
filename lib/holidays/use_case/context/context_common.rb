module Holidays
  module UseCase
    module Context
      module ContextCommon
        def make_date_array(dates_driver, regions, observed, informal)
          holidays = []
          dates_driver.each do |year, months|
            months.each do |month|
              next unless hbm = holidays_by_month_repo.find_by_month(month)
              hbm.each do |h|
                next unless in_region?(regions, h[:regions])
                next if h[:type] == :informal && !informal

                # range check feature.
                if h[:year_ranges]
                  valid_range_year = false
                  h[:year_ranges].each do |year_range|
                    next unless year_range.is_a?(Hash) && year_range.length == 1
                    next unless year_range.select{
                      |operator,year|[:before,"before",:after,"after",:limited,"limited",:between,"between"].include?(operator)}.count > 0
                    case year_range.keys.first
                    when :before,"before"
                      valid_range_year = true if year <= year_range[year_range.keys.first]
                    when :after,"after"
                      valid_range_year = true if year >= year_range[year_range.keys.first]
                    when :limited,"limited"
                      valid_range_year = true if year_range[year_range.keys.first].include?(year)
                    when :between,"between"
                      year_range[year_range.keys.first] = Range.new(*year_range[year_range.keys.first].split("..").map(&:to_i)) if year_range[year_range.keys.first].is_a?(String)
                      valid_range_year = true if year_range[year_range.keys.first].cover?(year)
                    end
                    break if valid_range_year
                  end
                  next unless valid_range_year
                end

                #FIXME I don't like this entire if/else. If it's a function, do something, else do some
                # weird mday logic? Bollocks. I think this should be a refactor target.
                if h[:function]
                  function_arguments = []

                  #FIXME This is a refactor target. We should also allow 'date'. Right now these are the only
                  # three things that we allow in. I think having a more testable, robust approach here is vital.
                  if h[:function_arguments].include?(:year)
                    function_arguments << year
                  end

                  if h[:function_arguments].include?(:month)
                    function_arguments << month
                  end

                  if h[:function_arguments].include?(:day)
                    function_arguments << h[:mday]
                  end

                  result = call_proc(h[:function], *function_arguments)

                  #FIXME This is a dangerous assumption. We should raise an error or something
                  #      if these procs return something unexpected.
                  #
                  # Procs may return either Date or an integer representing mday
                  if result.kind_of?(Date)
                    if h[:function_modifier]
                      result = result + h[:function_modifier] # NOTE: This could be a positive OR negative number.
                    end

                    month = result.month
                    mday = result.mday
                  else
                    mday = result
                  end
                else
                  mday = h[:mday] || day_of_month_calculator.call(year, month, h[:week], h[:wday])
                end

                # Silently skip bad mdays
                begin
                  date = Date.civil(year, month, mday)
                rescue; next; end

                #FIXME We should be checking the function arguments and passing in what is specified.
                # Right now all 'observed' functions require 'date' but that is by convention. Nothing
                # is requiring that. We should be more explicit.
                if observed && h[:observed]
                  date = call_proc(h[:observed], date)
                end

                holidays << {:date => date, :name => h[:name], :regions => h[:regions]}
              end
            end
          end
          holidays
        end

        def call_proc(function_id, *arguments)
          function = custom_methods_repo.find(function_id)
          raise Holidays::FunctionNotFound.new("Unable to find function with id '#{function_id}'") if function.nil?

          proc_result_cache_repo.lookup(function, *arguments)
        end

        # Check sub regions.
        #
        # When request :any, all holidays should be returned.
        # When requesting :ca_bc, holidays in :ca or :ca_bc should be returned.
        # When requesting :ca, holidays in :ca but not its subregions should be returned.
        def in_region?(requested, available) # :nodoc:
          return true if requested.include?(:any)

          # When an underscore is encountered, derive the parent regions
          # symbol and include both in the requested array.
          requested = requested.collect do |r|
            r.to_s =~ /_/ ? [r, r.to_s.gsub(/_[\w]*$/, '').to_sym] : r
          end

          requested = requested.flatten.uniq

          available.any? { |avail| requested.include?(avail) }
        end
      end
    end
  end
end
