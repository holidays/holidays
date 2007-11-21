module Holidays
  module MixinModule
    DEFINED_REGIONS = [:merged_a,:merged_b]

    def test_lambda(year)
      28
    end
  end
end

Holidays.class_eval do
  # merge regions and holidays
  new_regions = []
  if const_defined?(:DEFINED_REGIONS) 
    new_regions = const_get(:DEFINED_REGIONS)
    remove_const(:DEFINED_REGIONS)
  end
  const_set(:DEFINED_REGIONS, new_regions | Holidays::MixinModule::DEFINED_REGIONS)

  include Holidays::MixinModule
end