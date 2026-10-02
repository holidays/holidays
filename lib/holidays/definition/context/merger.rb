module Holidays
  module Definition
    module Context
      # Merge a new set of definitions into the Holidays module.
      class Merger
        def initialize(holidays_by_month_repo, regions_repo, custom_methods_repo, cache_repo, proc_result_cache_repo)
          @holidays_repo = holidays_by_month_repo
          @regions_repo = regions_repo
          @custom_methods_repo = custom_methods_repo
          @cache_repo = cache_repo
          @proc_result_cache_repo = proc_result_cache_repo
        end

        # Custom methods go in first so a name collision raises before any
        # region or holiday from the same definition set is registered.
        def call(target_regions, target_holidays, target_custom_methods, target_custom_method_sources = {})
          @custom_methods_repo.add(target_custom_methods, target_custom_method_sources)
          @regions_repo.add(target_regions)
          @holidays_repo.add(target_holidays)
        ensure
          @cache_repo.reset!
          @proc_result_cache_repo.reset!
        end
      end
    end
  end
end
