require 'date'

module Holidays
  module Definition
    module CustomMethods
      # ch custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/ch.yaml.
      module CH
        class << self
          def ch_vd_lundi_du_jeune_federal(year)
            date = Date.civil(year,9,1)
            # Find the first Sunday of September
            until date.wday.eql? 0 do
              date += 1
            end
            # There are 15 days between the first Sunday
            # and the Monday after the third Sunday
            date + 15
          end

          def ch_ge_jeune_genevois(year)
            date = Date.civil(year,9,1)
            # Find the first Sunday of September
            until date.wday.eql? 0 do
              date += 1
            end
            # Thursday is four days after Sunday
            date + 4
          end

          def ch_gl_naefelser_fahrt(year)
            date = Date.civil(year,4,1)
            # Find the first Thursday of April
            until date.wday.eql? 4 do
              date += 1
            end

            if date.eql?(Holidays::Factory::DateCalculator::Easter::Gregorian.easter_calculator.calculate_easter_for(year)-3)
              date += 7
            end
            date
          end

          def ch_be_zibelemaerit(year)
            date = Date.civil(year,11,1)
            # Find the first Monday of November
            until date.wday.eql? 1 do
              date += 1
            end
            # There are 21 days between the first monday
            # and the 4rth Monday after
            date + 21
          end
        end
      end
    end
  end
end
