module Holidays
  module Definition
    module Validator
      class Region
        def initialize(regions_repo)
          @regions_repo = regions_repo
        end

        def valid?(r)
          return false unless r.is_a?(Symbol)

          region = find_wildcard_base(r)

          (region == :any ||
           regions_repo.exists?(region) ||
           region_in_static_definitions?(region))
        end

        private

        attr_reader :regions_repo

        # Ex: :gb_ transformed to :gb
        def find_wildcard_base(region)
          r = region.to_s

          if r =~ /_$/
            base = r.split('_').first
          else
            base = r
          end

          base.to_sym
        end

        def region_in_static_definitions?(region)
          static_regions_definition = "#{DEFINITIONS_PATH}/REGIONS.rb"
          require static_regions_definition

          Holidays::REGIONS.include?(region)
        end
      end
    end
  end
end
