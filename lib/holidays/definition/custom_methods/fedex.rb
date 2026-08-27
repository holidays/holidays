require 'date'

module Holidays
  module Definition
    module CustomMethods
      # fedex custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/fedex.yaml.
      module FEDEX
        class << self
          def day_after_thanksgiving(year)
            Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, 11, 4, 4) + 1
          end
        end
      end
    end
  end
end
