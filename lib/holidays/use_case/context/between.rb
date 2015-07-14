module Holidays
  module UseCase
    module Context
      class Between
        def initialize(cache_repo, options_parser, holidays_by_month_repo, day_of_month_calculator, proc_cache_repo)
          @cache_repo = cache_repo
          @options_parser = options_parser
          @holidays_by_month_repo = holidays_by_month_repo
          @day_of_month_calculator = day_of_month_calculator
          @proc_cache_repo = proc_cache_repo
        end

        def call(start_date, end_date, *options)
          raise ArgumentError unless start_date && end_date

          # remove the timezone
          start_date = start_date.new_offset(0) + start_date.offset if start_date.respond_to?(:new_offset)
          end_date = end_date.new_offset(0) + end_date.offset if end_date.respond_to?(:new_offset)

          # get simple dates
          start_date, end_date = get_date(start_date), get_date(end_date)

          if cached_holidays = cache_repo.find(start_date, end_date, options)
            return cached_holidays
          end

          regions, observed, informal = options_parser.call(options)
          holidays = []

          dates = {}
          (start_date..end_date).each do |date|
            # Always include month '0' for variable-month holidays
            dates[date.year] = [0] unless dates[date.year]
            # TODO: test this, maybe should push then flatten
            dates[date.year] << date.month unless dates[date.year].include?(date.month)
          end

          dates.each do |year, months|
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

        attr_reader :cache_repo, :options_parser, :holidays_by_month_repo, :day_of_month_calculator, :proc_cache_repo

        def call_proc(function, year)
          proc_cache_repo.lookup(function, year)
        end

        #FIXME This is repeated in the main module. I need a better solution.
        def get_date(date)
          if date.respond_to?(:to_date)
            date.to_date
          else
            Date.civil(date.year, date.mon, date.mday)
          end
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
