require 'date'

module Holidays
  module Definition
    module CustomMethods
      # ie custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/ie.yaml.
      module IE
        class << self
          def ie_st_brigids_day(year)
            date = Date.civil(year, 2, 1)
            if date.wday == 5
              date
            else
              date + ((1 - date.wday) % 7)
            end
          end
        end
      end
    end
  end
end
