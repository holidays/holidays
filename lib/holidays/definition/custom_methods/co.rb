require 'date'

module Holidays
  module Definition
    module CustomMethods
      # co custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/co.yaml.
      module CO
        class << self
          def to_following_monday_if_not_monday(date)
            if date.wday > 1
              date += ( 8 - date.wday )
            elsif date.wday == 0
              date += 1
            end
            date
          end
        end
      end
    end
  end
end
