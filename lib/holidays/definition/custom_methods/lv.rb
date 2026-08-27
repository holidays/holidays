require 'date'

module Holidays
  module Definition
    module CustomMethods
      # lv custom holiday calculations, ported verbatim from the
      # +methods:+ block in definitions/lv.yaml.
      module LV
        class << self
          def lv_song_and_dance_festival_end_date(year)
            case year
            when 2018
              # https://likumi.lv/ta/id/281541 (Ministru kabineta rīkojums Nr. 252 "Par XXVI Vispārējo latviešu dziesmu un XVI Deju svētku norises laiku")
              Date.new(2018, 7, 8)
            when 2023
              # https://likumi.lv/ta/id/330067 (Ministru kabineta rīkojums Nr. 92 "Par XXVII Vispārējo latviešu dziesmu un XVII Deju svētku norises laiku")
              Date.new(2023, 7, 9)
            when 2028
              # Event's period/next year is known, but precise dates aren't.
              # Previously, dates were announced 2 years ahead, so on ~2026-05 this method would need to be revisited.
            end
          end
        end
      end
    end
  end
end
