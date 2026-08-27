require 'date'

module Holidays
  module Definition
    module CustomMethods
      # ca custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/ca.yaml.
      module CA
        class << self
          def ca_victoria_day(year)
            date = Date.civil(year,5,24)
            if date.wday > 1
              date -= (date.wday - 1)
            elsif date.wday == 0
              date -= 6
            end
            date
          end
        end
      end
    end
  end
end
