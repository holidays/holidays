require 'date'

module Holidays
  module Definition
    module CustomMethods
      # ph custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/ph.yaml.
      module PH
        class << self
          def ph_heroes_day(year)
            date = Date.new(year, 8, -1)
            date -= (date.wday - 1) % 7
            date
          end
        end
      end
    end
  end
end
