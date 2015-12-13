module Holidays
  module UseCase
    module Context
      class Between
        def initialize(holidays_by_month_repo, day_of_month_calculator, proc_cache_repo)
          @holidays_by_month_repo = holidays_by_month_repo
          @day_of_month_calculator = day_of_month_calculator
          @proc_cache_repo = proc_cache_repo
        end

        def call(start_date, end_date, dates_driver, regions, observed, informal)
          validate!(start_date, end_date, dates_driver, regions)

          holidays = []

          dates_driver.each do |year, months|
            months.each do |month|
              next unless hbm = holidays_by_month_repo.find_by_month(month)

              hbm.each do |h|
                next unless in_region?(regions, h[:regions])

                # Skip informal holidays unless they have been requested
                next if h[:type] == :informal and not informal

                if h[:function]
                  # Holiday definition requires a calculation
                  result = call_proc(h[:function], year)

                  # Procs may return either Date or an integer representing mday
                  if result.kind_of?(Date)
                    month = result.month
                    mday = result.mday
                  else
                    mday = result
                  end
                else
                  # Calculate the mday
                  mday = h[:mday] || day_of_month_calculator.call(year, month, h[:week], h[:wday])
                end

                # Silently skip bad mdays
                begin
                  date = Date.civil(year, month, mday)
                rescue; next; end

                # If the :observed option is set, calculate the date when the holiday
                # is observed.
                if observed and h[:observed]
                  date = call_proc(h[:observed], date)
                end

                if date.between?(start_date, end_date)
                  holidays << {:date => date, :name => h[:name], :regions => h[:regions]}
                end
              end
            end
          end

          holidays.sort{|a, b| a[:date] <=> b[:date] }
        end

        private

        attr_reader :holidays_by_month_repo, :day_of_month_calculator, :proc_cache_repo

        def validate!(start_date, end_date, dates_driver, regions)
          raise ArgumentError unless start_date
          raise ArgumentError unless end_date

          raise ArgumentError if dates_driver.nil? || dates_driver.empty?

          dates_driver.each do |year, months|
            raise ArgumentError if months.nil? || months.empty?
          end

          raise ArgumentError if regions.nil? || regions.empty?
        end

        def call_proc(function, year)
          proc_cache_repo.lookup(function, year)
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
