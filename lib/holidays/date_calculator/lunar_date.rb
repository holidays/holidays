module Holidays
  module DateCalculator
    # Copied from https://github.com/sunsidew/ruby_lunardate
    # Graciously allowed by JeeWoong Yang (https://github.com/sunsidew)
    class LunarDate
      attr_accessor :year, :month, :day, :is_leap_month

      def self.to_solar(year, month, day, is_leap_month = false, calendar_symbol = :ko)
        days = 0
        year_diff = year - 1900
        year_info = CALENDAR_YEAR_INFO_MAP[calendar_symbol]

        year_diff.times do |year_idx|
          days += year_info[year_idx][0]
        end

        (month - 1).times do |month_idx|
          total, _normal, _leap = lunardays_for_type(year_info[year_diff][month_idx + 1])
          days += total
        end

        days += (day - 1)

        if is_leap_month && year_info[year_diff][month] > 2
          days += lunardays_for_type(year_info[year_diff][month])[1]
        end

        SOLAR_START_DATE + days
      end

      def to_s
        format('%4d%02d%02d', year, month, day)
      end

      def inspect
        to_s
      end

      private

      KOREAN_LUNAR_YEAR_INFO = [
        [384, 1, 2, 1, 1, 2, 1, 2, 4, 2, 2, 1, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1].freeze,
        [355, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2].freeze,
        [383, 1, 2, 1, 2, 3, 2, 1, 1, 2, 2, 1, 2].freeze,
        [354, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1].freeze,
        [355, 2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [384, 1, 2, 2, 5, 1, 2, 1, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2].freeze,
        [384, 1, 4, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1].freeze,
        [384, 2, 1, 2, 1, 1, 4, 1, 2, 2, 1, 2, 2].freeze,
        [354, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2].freeze,
        [354, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2].freeze,
        [384, 2, 2, 1, 2, 4, 1, 2, 1, 2, 1, 1, 2].freeze,
        [355, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1].freeze,
        [384, 2, 3, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1].freeze,
        [355, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2].freeze,
        [384, 1, 2, 1, 1, 2, 1, 4, 2, 2, 1, 2, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2].freeze,
        [354, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2].freeze,
        [384, 2, 1, 2, 2, 3, 2, 1, 1, 2, 1, 2, 2].freeze,
        [354, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2].freeze,
        [354, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1].freeze,
        [385, 2, 1, 2, 4, 2, 1, 2, 2, 1, 2, 1, 2].freeze,
        [354, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1].freeze,
        [355, 2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2].freeze,
        [384, 1, 4, 1, 2, 1, 1, 2, 2, 1, 2, 2, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2].freeze,
        [383, 1, 2, 2, 1, 1, 4, 1, 2, 1, 2, 2, 1].freeze,
        [354, 2, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1].freeze,
        [355, 2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2].freeze,
        [384, 1, 2, 2, 1, 6, 1, 2, 1, 2, 1, 1, 2].freeze,
        [355, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2].freeze,
        [354, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1].freeze,
        [384, 2, 1, 5, 1, 2, 1, 2, 1, 2, 2, 2, 1].freeze,
        [354, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1].freeze,
        [384, 2, 2, 1, 1, 2, 1, 5, 1, 2, 2, 1, 2].freeze,
        [354, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [354, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1].freeze,
        [384, 2, 2, 1, 2, 2, 5, 1, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2].freeze,
        [355, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2].freeze,
        [384, 1, 1, 2, 5, 1, 2, 1, 2, 2, 1, 2, 2].freeze,
        [354, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2].freeze,
        [354, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2].freeze,
        [384, 2, 4, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2].freeze,
        [354, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [384, 2, 2, 1, 2, 1, 2, 3, 2, 1, 2, 1, 2].freeze,
        [354, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2].freeze,
        [384, 1, 2, 1, 2, 5, 2, 1, 2, 1, 2, 1, 2].freeze,
        [355, 1, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2, 2].freeze,
        [354, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2].freeze,
        [384, 2, 1, 5, 1, 1, 2, 1, 2, 1, 2, 2, 2].freeze,
        [354, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2].freeze,
        [384, 2, 1, 2, 1, 2, 1, 1, 4, 2, 1, 2, 2].freeze,
        [354, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1].freeze,
        [384, 2, 1, 2, 1, 2, 4, 2, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1].freeze,
        [384, 2, 1, 2, 3, 2, 1, 2, 1, 2, 2, 2, 1].freeze,
        [355, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2].freeze,
        [354, 1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 2].freeze,
        [383, 1, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 1].freeze,
        [355, 2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [384, 1, 2, 2, 1, 2, 1, 4, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2].freeze,
        [384, 1, 2, 1, 1, 4, 2, 1, 2, 2, 2, 1, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1].freeze,
        [354, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 2, 1].freeze,
        [384, 2, 2, 1, 4, 1, 2, 1, 1, 2, 2, 1, 2].freeze,
        [354, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2].freeze,
        [384, 2, 2, 1, 2, 1, 2, 1, 4, 2, 1, 1, 2].freeze,
        [354, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1].freeze,
        [355, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1].freeze,
        [384, 2, 1, 1, 2, 1, 6, 1, 2, 2, 1, 2, 1].freeze,
        [355, 2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2].freeze,
        [384, 2, 1, 2, 3, 2, 1, 1, 2, 2, 1, 2, 2].freeze,
        [354, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2].freeze,
        [384, 2, 1, 2, 2, 1, 1, 2, 1, 1, 4, 2, 2].freeze,
        [354, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2].freeze,
        [354, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1].freeze,
        [385, 2, 1, 2, 2, 1, 4, 2, 2, 1, 2, 1, 2].freeze,
        [354, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1].freeze,
        [355, 2, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2].freeze,
        [384, 1, 2, 1, 1, 4, 1, 2, 2, 1, 2, 2, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2].freeze,
        [354, 1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2].freeze,
        [383, 1, 2, 4, 2, 1, 2, 1, 1, 2, 1, 2, 1].freeze,
        [355, 2, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2].freeze,
        [384, 1, 2, 2, 1, 2, 2, 1, 4, 2, 1, 1, 2].freeze,
        [355, 1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2].freeze,
        [354, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1].freeze,
        [384, 2, 1, 1, 2, 3, 2, 2, 1, 2, 2, 2, 1].freeze,
        [354, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1].freeze,
        [354, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1].freeze,
        [384, 2, 2, 2, 3, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [354, 2, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1].freeze,
        [355, 2, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2].freeze,
        [384, 1, 4, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1, 1].freeze,
        [385, 2, 1, 2, 1, 2, 1, 4, 2, 2, 1, 2, 2].freeze,
        [354, 1, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2].freeze,
        [354, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2].freeze,
        [384, 2, 2, 1, 1, 4, 1, 2, 1, 2, 1, 2, 2].freeze,
        [354, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [354, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 1].freeze,
        [384, 2, 1, 6, 2, 1, 2, 1, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2].freeze,
        [384, 1, 2, 1, 2, 1, 2, 1, 2, 4, 2, 1, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2, 1].freeze,
        [355, 2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2].freeze,
        [384, 1, 2, 1, 2, 3, 2, 1, 2, 1, 2, 2, 2].freeze,
        [354, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2].freeze,
        [354, 2, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [384, 2, 1, 2, 4, 2, 1, 1, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2].freeze,
        [384, 1, 4, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1].freeze,
        [384, 2, 1, 2, 1, 1, 4, 2, 1, 2, 2, 2, 1].freeze,
        [355, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2].freeze,
        [354, 1, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 2].freeze,
        [383, 1, 2, 2, 1, 4, 1, 2, 1, 1, 2, 2, 1].freeze,
        [355, 2, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 2].freeze,
        [354, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1].freeze,
        [384, 2, 1, 4, 2, 1, 2, 2, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2].freeze,
        [384, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 4, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 1].freeze,
        [354, 2, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2].freeze,
        [384, 2, 2, 1, 2, 1, 5, 1, 1, 2, 2, 1, 2].freeze,
        [354, 2, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2].freeze,
        [354, 2, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1].freeze,
        [384, 2, 2, 1, 2, 4, 2, 1, 2, 1, 2, 1, 1].freeze,
        [355, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1].freeze,
        [355, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2].freeze,
        [384, 1, 4, 1, 2, 1, 2, 1, 2, 2, 2, 1, 2].freeze,
        [354, 1, 2, 1, 1, 2, 1, 1, 2, 2, 1, 2, 2].freeze,
        [384, 2, 1, 2, 1, 1, 2, 3, 2, 1, 2, 2, 2].freeze,
        [354, 2, 1, 2, 1, 1, 2, 1, 1, 2, 1, 2, 2].freeze,
        [354, 2, 1, 2, 2, 1, 1, 2, 1, 1, 2, 1, 2].freeze,
        [384, 2, 1, 2, 2, 5, 1, 2, 1, 1, 2, 1, 2].freeze,
        [354, 1, 2, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1].freeze,
        [355, 2, 1, 2, 1, 2, 2, 1, 2, 2, 1, 2, 1].freeze
      ].freeze

      MAX_YEAR_NUMBER = 150
      CALENDAR_YEAR_INFO_MAP = {
        ko: KOREAN_LUNAR_YEAR_INFO
      }.freeze

      LUNARDAYS_FOR_MONTHTYPE = {
        1 => [29, 29, 0],
        2 => [30, 30, 0],
        3 => [58, 29, 29],
        4 => [59, 30, 29],
        5 => [59, 29, 30],
        6 => [60, 30, 30]
      }.freeze

      SOLAR_START_DATE = Date.new(1900, 1, 31).freeze

      def initialize(year, month, day, is_leap_month = false)
        self.year = year
        self.month = month
        self.day = day
        self.is_leap_month = is_leap_month
      end

      class << self
        private

        def lunardays_for_type(month_type)
          LUNARDAYS_FOR_MONTHTYPE[month_type]
        end

        def get_days(solar_date)
          (solar_date - SOLAR_START_DATE).to_i
        end

        def in_this_days?(days, left_days)
          (days - left_days) < 0
        end

        def lunar_from_days(days, calendar_symbol)
          start_year = 1900
          target_month = 0
          is_leap_month = false
          matched = false
          year_info = CALENDAR_YEAR_INFO_MAP[calendar_symbol]

          MAX_YEAR_NUMBER.times do |year_idx|
            year_days = year_info[year_idx][0]
            if in_this_days?(days, year_days)
              12.times do |month_idx|
                total, normal, _leap = lunardays_for_type(year_info[year_idx][month_idx + 1])
                if in_this_days?(days, total)
                  unless in_this_days?(days, normal)
                    days -= normal
                    is_leap_month = true
                  end

                  matched = true
                  break
                end

                days -= total
                target_month += 1
              end
            end

            break if matched

            days -= year_days
            start_year += 1
          end

          lunar_date = new(start_year, target_month + 1, days + 1, is_leap_month)

          lunar_date
        end
      end
    end
  end 
end
