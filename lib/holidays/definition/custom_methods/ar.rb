require 'date'

module Holidays
  module Definition
    module CustomMethods
      # ar custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/ar.yaml.
      module AR
        class << self
          def to_nearest_monday(date)
            case date.wday
            when 5
              date += 3
            when 4
              date += 4
            when 3
              date -= 2
            when 2
              date -= 1
            end

            date
          end
        end
      end
    end
  end
end
