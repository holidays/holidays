require 'date'

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
          def cn_qingming(year)
            constant =
              case year
              when 1900..1999
                5.59
              when 2000..2099
                4.81
              else
                raise IndexError.new("Out of range")
              end
            y = year % 100
            Date.civil(year, 4, (y * 0.2422 + constant).floor - (y / 4))
          end
        end
      end
    end
  end
end
