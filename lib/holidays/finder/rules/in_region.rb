module Holidays
  module Finder
    module Rules
      class InRegion
        class << self
          def call(requested, available)
            return true if requested.include?(:any)

            # When an underscore is encountered, derive the parent regions
            # symbol and check for both.
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
end
