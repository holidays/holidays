module Holidays
  module Definition
    module Entity
      MergeResult = Struct.new(:updated_holidays_by_month, :updated_known_regions) do
        def initialize(from_hash)
          super(*from_hash.values_at(*members))
        end
      end
    end
  end
end
