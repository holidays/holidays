require 'holidays/definition/entity/merge_result'

module Holidays
  module Definition
    module Context
      # Merge a new set of definitions into the Holidays module.
      #
      # This method is automatically called when including holiday definition
      # files. This is accomplished because the Generator class generates the
      # definition source with this class explicitly.
      class Merger
        def call(known_regions, target_regions, existing_holidays_by_month, target_holidays)
          updated_regions = known_regions | target_regions
          updated_regions.uniq!

          updated_holidays_by_month = existing_holidays_by_month.dup

          target_holidays.each do |month, holiday_defs|
            updated_holidays_by_month[month] = [] unless updated_holidays_by_month[month]
            holiday_defs.each do |holiday_def|
              exists = false
              updated_holidays_by_month[month].each do |existing_def|
                if definition_exists?(existing_def, holiday_def)
                  # append regions
                  existing_def[:regions] << holiday_def[:regions]

                  # Should do this once we're done
                  existing_def[:regions].flatten!
                  existing_def[:regions].uniq!
                  exists = true
                end
              end

              updated_holidays_by_month[month] << holiday_def  unless exists
            end
          end

          Entity::MergeResult.new(
            updated_holidays_by_month: updated_holidays_by_month,
            updated_known_regions: updated_regions
          )
        end

        private

        def definition_exists?(existing_def, target_def)
          existing_def[:name] == target_def[:name] && existing_def[:wday] == target_def[:wday] && existing_def[:mday] == target_def[:mday] && existing_def[:week] == target_def[:week] && existing_def[:function_id] == target_def[:function_id] && existing_def[:type] == target_def[:type] && existing_def[:observed_id] == target_def[:observed_id]
        end
      end
    end
  end
end
