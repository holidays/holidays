module Holidays
  module Definition
    module Context
      # Merge a new set of definitions into the Holidays module.
      #
      # This method is automatically called when including holiday definition
      # files. This is accomplished because the Generator class generates the
      # definition source with this class explicitly.
      class Merger
        def initialize(holidays_by_month_repo, regions_repo)
          @holidays_repo = holidays_by_month_repo
          @regions_repo = regions_repo
        end

        def call(target_regions, target_holidays)
          regions_repo.add(target_regions)
          holidays_repo.add(target_holidays)
        end

        private

        attr_reader :holidays_repo, :regions_repo
      end
    end
  end
end
