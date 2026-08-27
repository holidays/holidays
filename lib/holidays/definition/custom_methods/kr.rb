module Holidays
  module Definition
    module CustomMethods
      # kr custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/kr.yaml.
      module KR
        class << self
          # Seollal eve is the day before Seollal (Korean New Year), which is
          # the first day of the first lunar month.
          def kr_seollal_eve(year, region)
            Holidays::Factory::Definition.custom_methods_repository.find("lunar_to_solar(year, month, day, region)").call(year, 1, 1, region) - 1
          end
        end
      end
    end
  end
end
