require 'date'

module Holidays
  module Definition
    module CustomMethods
      # tr custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/tr.yaml.
      module TR
        class << self
          def ramadan_feast(year)
            begin_of_ramadan_feast = {
                '2014' => Date.civil(2014, 7, 28),
                '2015' => Date.civil(2015, 7, 17),
                '2016' => Date.civil(2016, 7, 5),
                '2017' => Date.civil(2017, 6, 25),
                '2018' => Date.civil(2018, 6, 15),
                '2019' => Date.civil(2019, 6, 4),
                '2020' => Date.civil(2020, 5, 24),
                '2021' => Date.civil(2021, 5, 13),
                '2022' => Date.civil(2022, 5, 2),
                '2023' => Date.civil(2023, 4, 21),
                '2024' => Date.civil(2024, 4, 10),
                '2025' => Date.civil(2025, 3, 30),
                '2026' => Date.civil(2026, 3, 20),
                '2027' => Date.civil(2027, 3, 9),
                '2028' => Date.civil(2028, 2, 26),
                '2029' => Date.civil(2029, 2, 15),
                '2030' => Date.civil(2030, 2, 4)
            }
            begin_of_ramadan_feast[year.to_s]
          end

          def sacrifice_feast(year)
            begin_of_sacrifice_feast = {
                '2014' => Date.civil(2014, 10, 4),
                '2015' => Date.civil(2015, 9, 24),
                '2016' => Date.civil(2016, 9, 12),
                '2017' => Date.civil(2017, 9, 1),
                '2018' => Date.civil(2018, 8, 21),
                '2019' => Date.civil(2019, 8, 11),
                '2020' => Date.civil(2020, 7, 31),
                '2021' => Date.civil(2021, 7, 20),
                '2022' => Date.civil(2022, 7, 9),
                '2023' => Date.civil(2023, 6, 28),
                '2024' => Date.civil(2024, 6, 16),
                '2025' => Date.civil(2025, 6, 6),
                '2026' => Date.civil(2026, 5, 27),
                '2027' => Date.civil(2027, 5, 16),
                '2028' => Date.civil(2028, 5, 5),
                '2029' => Date.civil(2029, 4, 24),
                '2030' => Date.civil(2030, 4, 13)
            }
            begin_of_sacrifice_feast[year.to_s]
          end
        end
      end
    end
  end
end
