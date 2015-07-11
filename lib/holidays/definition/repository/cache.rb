module Holidays
  module Definition
    module Repository
      class Cache
        def initialize
          @cache = {}
          @cache_range = {}
        end

        def cache_between(start_date, end_date, cache_data, *options)
          raise ArgumentError unless cache_data

          @cache_range[options] = start_date..end_date
          @cache[options] = cache_data
        end

        def find(start_date, end_date, *options)
          if range = @cache_range[options]
            if range.begin <= start_date && range.end >= end_date
              return @cache[options].select do |holiday|
                holiday[:date] >= start_date && holiday[:date] <= end_date
              end
            end
          end
        end
      end
    end
  end
end
