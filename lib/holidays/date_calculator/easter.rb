module Holidays
  module DateCalculator
    class Easter
      # Get the date of Easter Sunday in a given year.  From Easter Sunday, it is
      # possible to calculate many traditional holidays in Western countries.
      # Returns a Date object.
      def calculate_easter_for(year)
        y = year
        a = y % 19
        b = y / 100
        c = y % 100
        d = b / 4
        e = b % 4
        f = (b + 8) / 25
        g = (b - f + 1) / 3
        h = (19 * a + b - d - g + 15) % 30
        i = c / 4
        k = c % 4
        l = (32 + 2 * e + 2 * i - h - k) % 7
        m = (a + 11 * h + 22 * l) / 451

        month = (h + l - 7 * m + 114) / 31
        day = ((h + l - 7 * m + 114) % 31) + 1

        Date.civil(year, month, day)
      end

      # A method to calculate the orthodox easter date, returns date in the Gregorian (western) calendar
      # Safe until appr. 4100 AD, when one leap day will be removed.
      # Returns a Date object.
      def calculate_orthodox_easter_for(year)
        y = year
        g = y % 19
        i = (19 * g + 15) % 30
        j = (year + year/4 + i) % 7
        j_month = 3 + (i - j + 40) / 44
        j_day = i - j + 28 - 31 * (j_month / 4)
        j_date = Date.civil(year, j_month, j_day)

        case
          # up until 1582, julian and gregorian easter dates were identical
        when year <= 1582
          offset = 0
          # between the years 1583 and 1699 10 days are added to the julian day count
        when (year >= 1583 and year <= 1699)
          offset = 10
          # after 1700, 1 day is added for each century, except if the century year is exactly divisible by 400 (in which case no days are added).
          # Safe until 4100 AD, when one leap day will be removed.
        when year >= 1700
          offset = (year - 1700).divmod(100)[0] + ((year - year.divmod(100)[1]).divmod(400)[1] == 0 ? 0 : 1) - (year - year.divmod(100)[1] - 1700).divmod(400)[0] + 10
        end

        # add offset to the julian day
        return Date.jd(j_date.jd + offset)
      end
    end
  end
end
