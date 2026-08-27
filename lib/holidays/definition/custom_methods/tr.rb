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
                '2020' => Date.civil(2020, 5, 24)
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
                '2020' => Date.civil(2020, 7, 31)
            }
            begin_of_sacrifice_feast[year.to_s]
          end
        end
      end
    end
  end
end
