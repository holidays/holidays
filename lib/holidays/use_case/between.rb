module Holidays
  module UseCase
    class Between
      def initialize(cache_range, cache, holidays_by_month, proc_cache, regions)
        @cache_range = cache_range
        @cache = cache
        @holidays_by_month = holidays_by_month
        @proc_cache = proc_cache
        @regions = regions
      end

      def call(start_date, end_date, *options)
        # remove the timezone
        start_date = start_date.new_offset(0) + start_date.offset if start_date.respond_to?(:new_offset)
        end_date = end_date.new_offset(0) + end_date.offset if end_date.respond_to?(:new_offset)

        # get simple dates
        start_date, end_date = get_date(start_date), get_date(end_date)

        if range = cache_range[options]
          if range.begin < start_date && range.end > end_date
            return cache[options].select do |holiday|
              holiday[:date] >= start_date && holiday[:date] <= end_date
            end
          end
        end

        regions, observed, informal = parse_options(options)
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
            next unless hbm = holidays_by_month[month]

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
                mday = h[:mday] || self.calculate_mday(year, month, h[:week], h[:wday])
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

        private

        attr_reader :cache_range, :cache, :holidays_by_month, :proc_cache, :regions
      end
    end
  end
