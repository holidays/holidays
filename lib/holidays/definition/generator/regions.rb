module Holidays
  module Definition
    module Generator
      class Regions
        def call(regions)
          validate!(regions)

          <<-EOF
# encoding: utf-8
module Holidays
  REGIONS = #{to_array(regions)}

  PARENT_REGION_LOOKUP = #{generate_parent_lookup(regions)}
end
EOF
        end

        private

        def validate!(regions)
          raise ArgumentError.new("regions cannot be missing") if regions.nil?
          raise ArgumentError.new("regions must be a hash") unless regions.is_a?(Hash)
          raise ArgumentError.new("regions cannot be empty") if regions.empty?
        end

        def to_array(regions)
          all_regions = []

          regions.each do |region, subregions|
            all_regions << subregions
          end

          all_regions.flatten.uniq
        end

        # generates a hash of regions to their parent region
        # eg. :au_nsw => :au
        def generate_parent_lookup(regions)
          lookup = {}
          regions.each do |region, subregions|
            subregions.each do |s|
              next if lookup.has_key?(s) # don't override already generated regions
              # don't set things like "south_america" as the region for countries like venezuela that we don't have states for
              next if subregions.count > 1 && regions.has_key?(s) && regions[s].count == 1
              lookup[s] = region
            end
          end

          lookup
        end
      end
    end
  end
end
