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
        global_methods = {
          "easter(year)" => Holidays.method(:easter).to_proc,
          "orthodox_easter(year)" => Holidays.method(:orthodox_easter).to_proc,
          "orthodox_easter_julian(year)" => Holidays.method(:orthodox_easter_julian).to_proc,
          "to_monday_if_sunday(date)" => Holidays.method(:to_monday_if_sunday).to_proc,
          "to_monday_if_weekend(date)" => Holidays.method(:to_monday_if_weekend).to_proc,
          "to_weekday_if_boxing_weekend(date)" => Holidays.method(:to_weekday_if_boxing_weekend).to_proc,
          "to_weekday_if_boxing_weekend_from_year(year)" => Holidays.method(:to_weekday_if_boxing_weekend_from_year).to_proc,
          "to_weekday_if_weekend(date)" => Holidays.method(:to_weekday_if_weekend).to_proc,
          "calculate_day_of_month(year, month, day, wday)" => Holidays.method(:calculate_day_of_month).to_proc,
        }


        Holidays.merge_defs([], {}, global_methods)
      end
    end
  end
end
