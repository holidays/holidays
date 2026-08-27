require 'date'

module Holidays
  module Definition
    module CustomMethods
      # fi custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/fi.yaml.
      module FI
        class << self
          def fi_juhannusaatto(year)
            date = Date.civil(year,6,19)
            if date.wday > 5 #if 19.6 is saturday
              date += 6
            else
              date += (5 - date.wday)
            end
            date
          end

          def fi_juhannuspaiva(year)
            date = Date.civil(year,6,20)
            date += (6 - date.wday)
            date
          end

          def fi_pyhainpaiva(year)
            date = Date.civil(year,10,31)
            date += (6 - date.wday)
            date
          end
        end
      end
    end
  end
end
