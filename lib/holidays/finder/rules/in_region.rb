module Holidays
  module Finder
    module Rules
      class InRegion
        class << self
          # Each requested region is checked on its own. It qualifies when one
          # of the available regions is the region itself or one of its
          # ancestors (us for us_ca) and none of the excluded regions is. The
          # rule matches when any requested region qualifies. :any always
          # matches, whatever is excluded.
          def call(requested, available, excluded = nil)
            return true if requested.include?(:any)

            excluded ||= []

            requested.any? do |region|
              lineage = lineage(region)

              (available & lineage).any? && (excluded & lineage).empty?
            end
          end

          private

          # The region and all of its parents, e.g. :us_ca_xx gives
          # [:us, :us_ca, :us_ca_xx].
          def lineage(region)
            chunks = region.to_s.split('_')

            1.upto(chunks.length).map { |n| chunks.first(n).join('_').to_sym }
          end
        end
      end
    end
  end
end
