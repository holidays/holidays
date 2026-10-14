require 'date'
require 'holidays/errors'

module Holidays
  module Definition
    module CustomMethods
      # cn custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/cn.yaml.
      module CN
        class << self
          # Qingming falls when the sun reaches celestial longitude 15 degrees,
          # which lands on 4 or 5 April. This is the standard solar-term
          # approximation; the century constant shifts between the 20th and
          # 21st centuries.
          #
          # The formula is off by one day in 2100 only: the sun reaches 15
          # degrees at 00:45 on 5 April 2100, Beijing time (JPL DE440s).
          def cn_qingming(year)
            return Date.civil(2100, 4, 5) if year == 2100

            constant =
              case year
              when 1900..1999
                5.59
              when 2000..2099
                4.81
              else
                raise Holidays::UnsupportedYearError, "cn_qingming covers 1900..2100, got #{year}"
              end
            y = year % 100
            Date.civil(year, 4, (y * 0.2422 + constant).floor - (y / 4))
          end
        end
      end
    end
  end
end
