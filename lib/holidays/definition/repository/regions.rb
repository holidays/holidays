module Holidays
  module Definition
    module Repository
      class Regions
        def initialize
          @regions = []
        end

        def all
          @regions
        end

        def add(regions)
          regions = [regions] unless regions.is_a?(Array)

          regions.each do |region|
            raise ArgumentError unless region.is_a?(Symbol)
          end

          @regions = @regions | regions
          @regions.uniq!
        end

        def exists?(region)
          raise ArgumentError unless region.is_a?(Symbol)
          @regions.include?(region)
        end

        def search(prefix)
          raise ArgumentError unless prefix.is_a?(String)
          @regions.select { |region| region.to_s =~ Regexp.new("^#{prefix}") }
        end
      end
    end
  end
end
