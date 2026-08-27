require 'date'

module Holidays
  module Definition
    module CustomMethods
      # is custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/is.yaml.
      module IS
        class << self
          def is_sumardagurinn_fyrsti(year)
            date = Date.civil(year,4,18)
            if date.wday < 4
              date += (4 - date.wday)
            else
              date += (11 - date.wday)
            end
            date
          end
        end
      end
    end
  end
end
