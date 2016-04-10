module Holidays
  module Option
    module Context
      class ParseOptions
        def initialize(regions_repo, region_validator)
          @regions_repo = regions_repo
          @region_validator = region_validator
        end

        # Returns [(arr)regions, (bool)observed, (bool)informal]
        def call(*options)
          options.flatten!

          #TODO This is garbage. These two deletes MUST come before the
          # parse_regions call, otherwise it thinks that :observed and :informal
          # are regions to parse. We should be splitting these things out.
          observed = options.delete(:observed) ? true : false
          informal = options.delete(:informal) ? true : false
          regions = parse_regions!(options)

          return regions, observed, informal
        end

        private

        attr_reader :regions_repo, :region_validator

        # Check regions against list of supported regions and return an array of
        # symbols.
        #
        # If a wildcard region is found (e.g. <tt>:ca_</tt>) it is expanded into all
        # of its available sub regions.
        def parse_regions!(regions)
          regions = [regions] unless regions.kind_of?(Array)
          return [:any] if regions.empty?

          regions = regions.collect { |r| r.to_sym }

          validate!(regions)

          # Found sub region wild-card
          regions.delete_if do |r|
            if r.to_s =~ /_$/
              load_containing_region(r.to_s)
              regions << regions_repo.search(r.to_s)
              true
            end
          end

          regions.flatten!

          require "#{DEFINITIONS_PATH}/north_america" if regions.include?(:us) # special case for north_america/US cross-linking

          regions.each do |region|
            unless region == :any or regions_repo.exists?(region)
              region_definition = "#{DEFINITIONS_PATH}/#{region.to_s}"
              begin
                require region_definition #FIXME This is unacceptable, we can't be loading external files while parsing options
              rescue LoadError
                # This could be a sub region that does not have any holiday
                # definitions of its own; try to load the containing region instead.
                if region.to_s =~ /_/
                  load_containing_region(region.to_s)
                else
                  raise UnknownRegionError, "Could not load #{region_definition}"
                end
              end
            end
          end

          regions
        end

        def validate!(regions)
          regions.each do |r|
            raise UnknownRegionError unless region_validator.valid?(r)
          end
        end

        # Derive the containing region from a sub region wild-card or a sub region
        # and load its definition. (Common code factored out from parse_regions)
        def load_containing_region(sub_reg)
          prefix = sub_reg.split('_').first
          region_definition = "#{DEFINITIONS_PATH}/#{prefix}"
          unless regions_repo.exists?(prefix.to_sym)
            begin
              require region_definition #FIXME This is not acceptable, we can't be loading external things while parsing options.
            rescue LoadError
              raise UnknownRegionError, "Could not load #{region_definition}"
            end
          end
        end
      end
    end
  end
end
