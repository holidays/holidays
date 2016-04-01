module Holidays
  module DateCalculator
    class WeekendModifier
      # Move date to Monday if it occurs on a Saturday on Sunday.
      # Used as a callback function.
      def to_monday_if_weekend(date)
        date += 1 if date.wday == 0
        date += 2 if date.wday == 6
        date
      end

      # Move date to Monday if it occurs on a Sunday.
      # Used as a callback function.
      def to_monday_if_sunday(date)
        date += 1 if date.wday == 0
        date
      end

      # if Christmas falls on a Sunday, move it to the next Tuesday (Boxing Day will go on Monday)
      # if Christmas falls on a Saturday, move it to the next Monday (Boxing Day will be Sunday and potentially Tuesday)
      # used as a callback function, if xmas is not observed on the 25th
      def xmas_to_weekday_if_weekend(year)
        to_tuesday_if_sunday_or_monday_if_saturday(Date.civil(year, 12, 25))
      end

      # Move Boxing Day if it falls on a weekend, leaving room for Christmas.
      # Used as a callback function.
      def to_weekday_if_boxing_weekend(date)
        if date.wday == 6 || date.wday == 0
          date += 2
        elsif date.wday == 1 # https://github.com/holidays/holidays/issues/27
          date += 1
        end

        date
      end

      # if Christmas falls on a Saturday, move it to the next Monday (Boxing Day will be Sunday and potentially Tuesday)
      # if Christmas falls on a Sunday, move it to the next Tuesday (Boxing Day will go on Monday)
      #
      # if Boxing Day falls on a Saturday, move it to the next Monday (Christmas will go on Friday)
      # if Boxing Day falls on a Sunday, move it to the next Tuesday (Christmas will go on Saturday & Monday)
      def to_tuesday_if_sunday_or_monday_if_saturday(date)
        date += 2 if [0, 6].include?(date.wday)
        date
      end

      # Call to_weekday_if_boxing_weekend but first get date based on year
      # Used as a callback function.
      def to_weekday_if_boxing_weekend_from_year_or_to_tuesday_if_monday(year)
        to_weekday_if_boxing_weekend(Date.civil(year, 12, 26))
      end

      # Call to_weekday_if_boxing_weekend but first get date based on year
      # Used as a callback function.
      def to_weekday_if_boxing_weekend_from_year(year)
        to_tuesday_if_sunday_or_monday_if_saturday(Date.civil(year, 12, 26))
      end

      # Move date to Monday if it occurs on a Sunday or to Friday if it occurs on a
      # Saturday.
      # Used as a callback function.
      def to_weekday_if_weekend(date)
        date += 1 if date.wday == 0
        date -= 1 if date.wday == 6
        date
      end
    end
  end
end
