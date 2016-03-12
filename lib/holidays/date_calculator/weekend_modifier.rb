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

      # Move Boxing Day if it falls on a weekend, leaving room for Christmas.
      # Used as a callback function.
      def to_weekday_if_boxing_weekend(date)
        if date.wday == 6 || date.wday == 0
          date += 2
        elsif date.wday == 1
          date += 1
        end

        date
      end

      # Call to_weekday_if_boxing_weekend but first get date based on year
      # Used as a callback function.
      def to_weekday_if_boxing_weekend_from_year(year)
        to_weekday_if_boxing_weekend(Date.civil(year, 12, 26))
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
