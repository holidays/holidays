module Holidays
  module Definition
    module Context
      # Merge a new set of definitions into the Holidays module.
      class Merger
        def initialize(holidays_by_month_repo, regions_repo, custom_methods_repo)
          @holidays_repo = holidays_by_month_repo
          @regions_repo = regions_repo
          @custom_methods_repo = custom_methods_repo
        end

        def call(target_regions, target_holidays, target_custom_methods, target_custom_method_sources = {})
          @regions_repo.add(target_regions)
          @holidays_repo.add(target_holidays)
          @custom_methods_repo.add(
            target_custom_methods,
            target_custom_method_sources,
            derive_function_regions(target_holidays),
          )
        end

        private

        # Builds a map of {func_id => [regions]} from the holiday definitions
        # so the custom_methods repo knows which regions each function belongs to.
        def derive_function_regions(holidays_by_month)
          holidays_by_month.each_with_object({}) do |(_, definitions), result|
            definitions.each do |defn|
              next unless defn[:function]
              result[defn[:function]] ||= []
              result[defn[:function]] |= Array(defn[:regions])
            end
          end
        end
      end
    end
  end
end
