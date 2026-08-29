require 'holidays/definition/custom_methods/registry'

module Holidays
  # Runs once at require time (see the bottom of lib/holidays.rb). Despite the
  # historical name of its alias, this does NOT load per-region holiday data;
  # that happens lazily in Definition::Context::Load. What it does:
  #   1. Register the built-in calculation procs (easter, weekend modifiers,
  #      lunar_to_solar, calculate_day_of_month) into custom_methods_repository.
  #   2. Register the native per-region custom methods (CustomMethods.all).
  #   3. Require generated_definitions/REGIONS.rb (the region-name list only).
  class Bootstrap
    class << self
      def call
        global_methods = {
          "easter(year)" => gregorian_easter.method(:calculate_easter_for).to_proc,
          "orthodox_easter(year)" => gregorian_easter.method(:calculate_orthodox_easter_for).to_proc,
          "orthodox_easter_julian(year)" => julian_easter.method(:calculate_orthodox_easter_for).to_proc,
          "to_monday_if_sunday(date)" => weekend_modifier.method(:to_monday_if_sunday).to_proc,
          "to_monday_if_weekend(date)" => weekend_modifier.method(:to_monday_if_weekend).to_proc,
          "to_weekday_if_boxing_weekend(date)" => weekend_modifier.method(:to_weekday_if_boxing_weekend).to_proc,
          "to_weekday_if_boxing_weekend_from_year(year)" => weekend_modifier.method(:to_weekday_if_boxing_weekend_from_year).to_proc,
          "to_weekday_if_weekend(date)" => weekend_modifier.method(:to_weekday_if_weekend).to_proc,
          "calculate_day_of_month(year, month, day, wday)" => day_of_month_calculator.method(:call).to_proc,
          "to_weekday_if_boxing_weekend_from_year_or_to_tuesday_if_monday(year)" => weekend_modifier.method(:to_weekday_if_boxing_weekend_from_year_or_to_tuesday_if_monday).to_proc,
          "to_tuesday_if_sunday_or_monday_if_saturday(date)" => weekend_modifier.method(:to_tuesday_if_sunday_or_monday_if_saturday).to_proc,
          "lunar_to_solar(year, month, day, region)" => lunar_date.method(:to_solar).to_proc,
          "to_the_weekday_after(date)" => weekend_modifier.method(:to_the_weekday_after).to_proc,
          "to_the_second_weekday_after(date)" => weekend_modifier.method(:to_the_second_weekday_after).to_proc,
          "to_previous_day_if_leap_year(date)" => weekend_modifier.method(:to_previous_day_if_leap_year).to_proc,
        }

        Factory::Definition.custom_methods_repository.add(global_methods)

        # Native per-region custom methods (replaces the old YAML methods:/ruby: blocks).
        Factory::Definition.custom_methods_repository.add(Holidays::Definition::CustomMethods.all)

        static_regions_definition = "#{Holidays::DEFINITIONS_PATH}/REGIONS.rb"
        require static_regions_definition
      end

      private

      def gregorian_easter
        Factory::DateCalculator::Easter::Gregorian.easter_calculator
      end

      def julian_easter
        Factory::DateCalculator::Easter::Julian.easter_calculator
      end

      def weekend_modifier
        Factory::DateCalculator.weekend_modifier
      end

      def day_of_month_calculator
        Factory::DateCalculator.day_of_month_calculator
      end

      def lunar_date
        Factory::DateCalculator.lunar_date
      end
    end
  end

  private_constant :Bootstrap
end
