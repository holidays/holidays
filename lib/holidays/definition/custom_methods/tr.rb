require 'date'

module Holidays
  module Definition
    module CustomMethods
      # tr custom holiday calculations.
      #
      # Ramazan Bayramı is 1 Shawwal and Kurban Bayramı is 10 Dhul-Hijjah of
      # the Hijri calendar. Both are derived from the arithmetic Islamic
      # calendar (Holidays::DateCalculator::HijriDate). The civil holidays are
      # proclaimed by Türkiye's Diyanet and in most years so far have landed a
      # day (2016 Ramazan Bayramı, two days) before the arithmetic result;
      # DIYANET_OVERRIDES pins those years to the proclaimed date. Years with
      # no entry fall back to the calculation. See definitions#377.
      module TR
        SHAWWAL = 10
        DHU_AL_HIJJAH = 12

        # Proclaimed first days that differ from the arithmetic calendar,
        # keyed by [feast, gregorian_year]. Sourced from the Diyanet dates
        # that the definition file previously carried as a fixed table, plus
        # https://vakithesaplama.diyanet.gov.tr/resmitatiller.php for 2021-2030.
        DIYANET_OVERRIDES = {
          [:ramadan_feast, 2014] => Date.new(2014, 7, 28),
          [:ramadan_feast, 2015] => Date.new(2015, 7, 17),
          [:ramadan_feast, 2016] => Date.new(2016, 7, 5),
          [:ramadan_feast, 2017] => Date.new(2017, 6, 25),
          [:ramadan_feast, 2019] => Date.new(2019, 6, 4),
          [:ramadan_feast, 2022] => Date.new(2022, 5, 2),
          [:ramadan_feast, 2023] => Date.new(2023, 4, 21),
          [:ramadan_feast, 2025] => Date.new(2025, 3, 30),
          [:ramadan_feast, 2027] => Date.new(2027, 3, 9),
          [:ramadan_feast, 2028] => Date.new(2028, 2, 26),
          [:ramadan_feast, 2030] => Date.new(2030, 2, 4),

          [:sacrifice_feast, 2014] => Date.new(2014, 10, 4),
          [:sacrifice_feast, 2016] => Date.new(2016, 9, 12),
          [:sacrifice_feast, 2017] => Date.new(2017, 9, 1),
          [:sacrifice_feast, 2018] => Date.new(2018, 8, 21),
          [:sacrifice_feast, 2019] => Date.new(2019, 8, 11),
          [:sacrifice_feast, 2022] => Date.new(2022, 7, 9),
          [:sacrifice_feast, 2023] => Date.new(2023, 6, 28),
          [:sacrifice_feast, 2024] => Date.new(2024, 6, 16),
          [:sacrifice_feast, 2025] => Date.new(2025, 6, 6),
          [:sacrifice_feast, 2027] => Date.new(2027, 5, 16),
          [:sacrifice_feast, 2030] => Date.new(2030, 4, 13),
        }.freeze

        class << self
          def ramadan_feast(year)
            feast(:ramadan_feast, year, SHAWWAL, 1)
          end

          def sacrifice_feast(year)
            feast(:sacrifice_feast, year, DHU_AL_HIJJAH, 10)
          end

          private

          def feast(name, year, hijri_month, hijri_day)
            DIYANET_OVERRIDES[[name, year]] ||
              Holidays::Factory::DateCalculator.hijri_date.gregorian_year_occurrence(year, hijri_month, hijri_day)
          end
        end
      end
    end
  end
end
