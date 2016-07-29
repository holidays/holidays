module Holidays
  class LoadAllDefinitions
    class << self
      def call
        path = File.expand_path(File.dirname(__FILE__)) + "/../#{Holidays::DEFINITIONS_PATH}/"

        Dir.foreach(path) do |item|
          next if item == '.' or item == '..'

          target = path+item
          next if File.extname(target) != '.rb'

          require target
        end

        #FIXME I need a better way to do this. I'm thinking of putting these 'common' methods
        # into some kind of definition file so it can be loaded automatically but I'm afraid
        # of making that big of a breaking API change since these are public. For the time
        # being I'll load them manually like this.
        #
        # NOTE: These are no longer public! We can do whatever we want here!
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
          "xmas_to_weekday_if_weekend(year)" => weekend_modifier.method(:xmas_to_weekday_if_weekend).to_proc,
          "to_tuesday_if_sunday_or_monday_if_saturday(date)" => weekend_modifier.method(:to_tuesday_if_sunday_or_monday_if_saturday).to_proc,
        }

        Factory::Definition.custom_methods_repository.add(global_methods)
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
    end
  end
end
