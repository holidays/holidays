module Holidays
  module Finder
    module Context
      class ParseOptions
        def initialize(regions_repo, region_validator, definition_merger)
          @regions_repo = regions_repo
          @region_validator = region_validator
          @definition_merger = definition_merger
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

        # Check regions against list of supported regions and return an array of
        # symbols.
        #
        # If a wildcard region is found (e.g. :ca_) it is expanded into all
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
              regions << @regions_repo.search(r.to_s)
              true
            end
          end

          regions.flatten!

          load_definition_data("north_america") if regions.include?(:us) # special case for north_america/US cross-linking

          regions.each do |region|
            unless region == :any || @regions_repo.exists?(region)
              begin
                load_definition_data(region.to_s)
              rescue NameError, LoadError => e
                # This could be a sub region that does not have any holiday
                # definitions of its own; try to load the containing region instead.
                if region.to_s =~ /_/
                  load_containing_region(region.to_s)
                else
                  raise UnknownRegion.new(e), "Could not load #{region.to_s}"
                end
              end
            end
          end

          regions
        end

        def validate!(regions)
          regions.each do |r|
            raise InvalidRegion unless @region_validator.valid?(r)
          end
        end

        # Derive the containing region from a sub region wild-card or a sub region
        # and load its definition. (Common code factored out from parse_regions)
        def load_containing_region(sub_reg)
          prefix = sub_reg.split('_').first

          return if @regions_repo.exists?(prefix.to_sym)

          begin
            load_definition_data(prefix)
          rescue NameError, LoadError => e
            raise UnknownRegionError.new(e), "Could not load region prefix: #{prefix.to_s}, original subregion: #{sub_reg.to_s}"
          end
        end

        def load_definition_data(region)
          # Lazy loading of definition files. We verify the region doesn't
          # contain malicious stuff in the initial validation.
          region_definition_file = "#{DEFINITIONS_PATH}/#{region}"
          require region_definition_file

          target_region_module = Module.const_get("Holidays").const_get(region.upcase)

          @definition_merger.call(
            target_region_module.defined_regions,
            target_region_module.holidays_by_month,
            target_region_module.custom_methods,
          )
        end
      end
    end
  end
end
