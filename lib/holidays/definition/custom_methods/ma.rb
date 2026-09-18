require 'date'

module Holidays
  module Definition
    module CustomMethods
      # ma custom holiday calculations.
      #
      # Eid al-Fitr is 1 Shawwal and Eid al-Adha is 10 Dhul-Hijjah of the
      # Hijri calendar. Both are derived from the arithmetic Islamic calendar
      # (Holidays::DateCalculator::HijriDate). The civil holidays are
      # proclaimed by Morocco's Ministry of Habous and Islamic Affairs and in
      # some years land a day off from the arithmetic result; MINISTRY_OVERRIDES
      # pins those years to the proclaimed date. Years with no entry fall back
      # to the calculation. See holidays#392.
      module MA
        SHAWWAL = 10
        DHU_AL_HIJJAH = 12

        # Proclaimed first days that differ from the arithmetic calendar,
        # keyed by [feast, gregorian_year]. Sourced from the Ministry of
        # Habous and Islamic Affairs communiques reported via maroc.ma,
        # Hespress, and Morocco World News.
        MINISTRY_OVERRIDES = {
          [:eid_al_fitr, 2022] => Date.new(2022, 5, 2),

          [:eid_al_adha, 2021] => Date.new(2021, 7, 21),
        }.freeze

        class << self
          def eid_al_fitr(year)
            feast(:eid_al_fitr, year, SHAWWAL, 1)
          end

          def eid_al_adha(year)
            feast(:eid_al_adha, year, DHU_AL_HIJJAH, 10)
          end

          private

          def feast(name, year, hijri_month, hijri_day)
            MINISTRY_OVERRIDES[[name, year]] ||
              Holidays::Factory::DateCalculator.hijri_date.gregorian_year_occurrence(year, hijri_month, hijri_day)
          end
        end
      end
    end
  end
end
