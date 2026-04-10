module Holidays
  module Definition
    module Repository
      class CustomMethods
        def initialize
          @custom_methods = {}
          @custom_method_sources = {}
          @regional_overrides = {}
        end

        # Adds new custom methods to the repository.
        #
        # new_sources:      {func_id => source_string} — used to detect genuine
        #                   conflicts (same name, different logic) vs reloads.
        # function_regions: {func_id => [regions]} — which regions the incoming
        #                   methods belong to, derived from the holiday definitions.
        #
        # When a conflict is detected the incoming method is stored as a regional
        # override keyed by its regions. find() then resolves the right
        # implementation at lookup time using the queried region.
        def add(new_custom_methods, new_sources = {}, function_regions = {})
          raise ArgumentError if new_custom_methods.nil?

          new_custom_methods.each do |key, method|
            new_source = new_sources[key]

            if @custom_methods.key?(key)
              existing_source = @custom_method_sources[key]

              if new_source && existing_source && new_source != existing_source
                # Genuine conflict: same name but different source code.
                # Store as a regional override so region-aware lookups work
                # without touching the holiday definitions.
                regions = function_regions[key] || []
                @regional_overrides[key] ||= []
                @regional_overrides[key] << { regions: regions, proc: method }
              else
                # Same source or no source to compare — safe to overwrite
                # (handles reloading the same definition file).
                @custom_methods[key] = method
                @custom_method_sources[key] = new_source if new_source
              end
            else
              @custom_methods[key] = method
              @custom_method_sources[key] = new_source if new_source
            end
          end
        end

        # Returns the proc for the given method_id.
        #
        # When a region is supplied, regional overrides are checked first so
        # that conflicting methods with the same name but different logic each
        # resolve to their own implementation.
        def find(method_id, region = nil)
          raise ArgumentError if method_id.nil? || method_id.empty?

          if region && @regional_overrides[method_id]
            override = @regional_overrides[method_id].find { |o| o[:regions].include?(region) }
            return override[:proc] if override
          end

          @custom_methods[method_id]
        end
      end
    end
  end
end
