require 'date'

module Holidays
  module Definition
    module CustomMethods
      # se custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/se.yaml.
      module SE
        class << self
          def se_midsommardagen(year)
            date = Date.civil(year,6,20)
            date += (6 - date.wday)
            date
          end

          def se_alla_helgons_dag(year)
            date = Date.civil(year,10,31)
            date += (6 - date.wday)
            date
          end
        end
      end
    end
  end
end
