require 'date'

module Holidays
  module Definition
    module CustomMethods
      # nz custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/nz.yaml.
      module NZ
        class << self
          def closest_monday(date)
            if [1, 2, 3, 4].include?(date.wday)
              date -= (date.wday - 1)
            elsif 0 == date.wday
              date += 1
            else
              date += 8 - date.wday
            end
            date
          end

          def previous_friday(date)
            date - 3
          end

          def next_week(date)
            date + 7
          end

          def nz_canterbury_anniversary(year)
            date = Date.civil(year, 11, 1)
            date += 1 until date.tuesday?
            date += 1
            date += 1 until date.friday?
            date + 7
          end

          def matariki(year)
            @matariki_dates ||= {
            '2022' => Date.civil(2022, 6, 24),
            '2023' => Date.civil(2023, 7, 14),
            '2024' => Date.civil(2024, 6, 28),
            '2025' => Date.civil(2025, 6, 20),
            '2026' => Date.civil(2026, 7, 10),
            '2027' => Date.civil(2027, 6, 25),
            '2028' => Date.civil(2028, 7, 14),
            '2029' => Date.civil(2029, 7, 6),
            '2030' => Date.civil(2030, 6, 21),
            '2031' => Date.civil(2031, 7, 11),
            '2032' => Date.civil(2032, 7, 2),
            '2033' => Date.civil(2033, 6, 24),
            '2034' => Date.civil(2034, 7, 7),
            '2035' => Date.civil(2035, 6, 29),
            '2036' => Date.civil(2036, 7, 18),
            '2037' => Date.civil(2037, 7, 10),
            '2038' => Date.civil(2038, 6, 25),
            '2039' => Date.civil(2039, 7, 15),
            '2040' => Date.civil(2040, 7, 6),
            '2041' => Date.civil(2041, 7, 19),
            '2042' => Date.civil(2042, 7, 11),
            '2043' => Date.civil(2043, 7, 3),
            '2044' => Date.civil(2044, 6, 24),
            '2045' => Date.civil(2045, 7, 7),
            '2046' => Date.civil(2046, 6, 29),
            '2047' => Date.civil(2047, 7, 19),
            '2048' => Date.civil(2048, 7, 3),
            '2049' => Date.civil(2049, 6, 25),
            '2050' => Date.civil(2050, 7, 15),
            '2051' => Date.civil(2051, 6, 30),
            '2052' => Date.civil(2052, 6, 21),
            }
            @matariki_dates[year.to_s]
          end
        end
      end
    end
  end
end
