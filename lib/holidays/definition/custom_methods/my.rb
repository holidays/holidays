require 'date'

module Holidays
  module Definition
    module CustomMethods
      # my custom holiday calculations.
      #
      # Hari Raya Puasa (Eid al-Fitr) is 1 Shawwal and Hari Raya Haji (Eid
      # al-Adha) is 10 Dhul-Hijjah of the Hijri calendar. Both are derived
      # from the arithmetic Islamic calendar (Holidays::DateCalculator::HijriDate).
      # The civil holidays are fixed by the Yang di-Pertuan Agong (Conference
      # of Rulers) on JAKIM's moon-sighting advice and in some years have
      # landed a day before the arithmetic result; GAZETTE_OVERRIDES pins
      # those years to the gazetted date. Years with no entry fall back to
      # the calculation. See holidays#392.
      module MY
        SHAWWAL = 10
        DHU_AL_HIJJAH = 12

        # Gazetted first days that differ from the arithmetic calendar,
        # keyed by [feast, gregorian_year]. Sourced from the official
        # Malaysian public holiday gazette, cross-checked against
        # definitions/sg.yaml (agrees in every overlapping year 2017-2026).
        GAZETTE_OVERRIDES = {
          [:hari_raya_puasa, 2014] => Date.new(2014, 7, 28),
          [:hari_raya_puasa, 2015] => Date.new(2015, 7, 17),
          [:hari_raya_puasa, 2016] => Date.new(2016, 7, 6),
          [:hari_raya_puasa, 2017] => Date.new(2017, 6, 25),
          [:hari_raya_puasa, 2026] => Date.new(2026, 3, 21),

          [:hari_raya_haji, 2016] => Date.new(2016, 9, 12),
          [:hari_raya_haji, 2017] => Date.new(2017, 9, 1),
          [:hari_raya_haji, 2019] => Date.new(2019, 8, 11),
        }.freeze

        class << self
          def hari_raya_puasa(year)
            feast(:hari_raya_puasa, year, SHAWWAL, 1)
          end

          def hari_raya_haji(year)
            feast(:hari_raya_haji, year, DHU_AL_HIJJAH, 10)
          end

          private

          def feast(name, year, hijri_month, hijri_day)
            GAZETTE_OVERRIDES[[name, year]] ||
              Holidays::Factory::DateCalculator.hijri_date.gregorian_year_occurrence(year, hijri_month, hijri_day)
          end
        end
      end
    end
  end
end
