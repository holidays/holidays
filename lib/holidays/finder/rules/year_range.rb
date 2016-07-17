# Please note that only one condition needs to match in order for `call` to return `true.
# See the test file for this class for specific examples.
module Holidays
  module Finder
    module Rules
      class YearRange
        class << self
          BEFORE = :before
          AFTER = :after
          LIMITED = :limited
          BETWEEN = :between

          #TODO Can we just accept symbols here? Why accept strings?
          VALID_OPERATORS = [
            BEFORE, BEFORE.to_s,
            AFTER, AFTER.to_s,
            LIMITED, LIMITED.to_s,
            BETWEEN, BETWEEN.to_s
          ]

          def call(target_year, year_range_definitions)
            validate!(target_year, year_range_definitions)

            matched = false
            year_range_definitions.each do |range_defs|
              next unless range_defs.is_a?(Hash) && range_defs.length == 1

              operator = range_defs.keys.first
              year_range = range_defs.values.first

              case operator
              when BEFORE, BEFORE.to_s
                matched = target_year <= year_range
              when AFTER, AFTER.to_s
                matched = target_year >= year_range
              when LIMITED, LIMITED.to_s
                if year_range.is_a?(Array)
                  matched = year_range.include?(target_year)
                else
                  matched = year_range == target_year
                end
              when BETWEEN, BETWEEN.to_s
                matched = year_range.cover?(target_year)
              end

              break if matched == true
            end

            matched
          end

          private

          def validate!(target_year, year_ranges)
            raise ArgumentError.new("target_year must be a number") unless target_year.is_a?(Integer)
            raise ArgumentError.new("year_ranges cannot be missing") if year_ranges.nil? || year_ranges.empty?

            year_ranges.each do |range|
              raise ArgumentError.new("year_ranges must include only hashes") unless range.is_a?(Hash)
              raise ArgumentError.new("year_ranges cannot include empty hashes") if range.empty?
              raise ArgumentError.new("year_ranges entries can only include one operator") unless range.count == 1

              operator = range.keys.first
              range = range.values.first

              raise ArgumentError.new("Invalid operator found: '#{operator}'") unless VALID_OPERATORS.include?(operator)

              case operator
              when BEFORE, BEFORE.to_s, AFTER, AFTER.to_s
                raise ArgumentError.new(":before and :after operator value must be a number, received: '#{range}'") unless range.is_a?(Integer)
              when LIMITED, LIMITED.to_s
                raise ArgumentError.new(":limited operator value must be an array, received: '#{range}'") unless range.is_a?(Array) || range.is_a?(Integer)
              when BETWEEN, BETWEEN.to_s
                raise ArgumentError.new(":between operator value must be a range, received: '#{range}'") unless range.is_a?(Range)
              end
            end
          end
        end
      end
    end
  end
end
