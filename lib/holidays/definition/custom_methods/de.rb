require 'date'

module Holidays
  module Definition
    module CustomMethods
      # de custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/de.yaml.
      module DE
        class << self
          def de_buss_und_bettag(year)
            date = Date.civil(year,11,23)
            if date.wday > 3
              date -= (date.wday - 3)
            else
              date -= (date.wday + 4)
            end
            date
          end
        end
      end
    end
  end
end
