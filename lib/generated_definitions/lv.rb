# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: definitions/lv.yaml
  #
  # All the definitions are available at https://github.com/holidays/holidays
  module LV # :nodoc:
    def self.defined_regions
      [:lv]
    end

    def self.holidays_by_month
      {
                0 => [{:function => "easter(year)", :function_arguments => [:year], :function_modifier => -2, :name => "Lielā Piektdiena", :regions => [:lv]},
            {:function => "easter(year)", :function_arguments => [:year], :name => "Pirmās Lieldienas", :regions => [:lv]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 1, :name => "Otrās Lieldienas", :regions => [:lv]},
            {:function => "easter(year)", :function_arguments => [:year], :function_modifier => 49, :name => "Vasarsvētki", :regions => [:lv]},
            {:function => "lv_song_and_dance_festival_end_date(year)", :function_arguments => [:year], :year_ranges => { :from => 2018 },:observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "Vispārējo latviešu Dziesmu un deju svētku noslēguma diena", :regions => [:lv]}],
      1 => [{:mday => 1, :name => "Jaungada diena", :regions => [:lv]}],
      5 => [{:mday => 1, :name => "Darba svētki, Latvijas Republikas Satversmes sapulces sasaukšanas diena", :regions => [:lv]},
            {:mday => 4, :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "Latvijas Republikas Neatkarības atjaunošanas diena", :regions => [:lv]},
            {:wday => 0, :week => 2, :name => "Mātes diena", :regions => [:lv]},
            {:mday => 29, :year_ranges => { :limited => [2023] },:name => "Diena, kad Latvijas hokeja komanda ieguva bronzas medaļu 2023. gada Pasaules hokeja čempionātā", :regions => [:lv]}],
      6 => [{:mday => 23, :name => "Līgo diena", :regions => [:lv]},
            {:mday => 24, :name => "Jāņu diena", :regions => [:lv]}],
      9 => [{:mday => 24, :year_ranges => { :limited => [2018] },:name => "Viņa Svētības pāvesta Franciska pastorālās vizītes Latvijā diena", :regions => [:lv]}],
      11 => [{:mday => 18, :observed => "to_monday_if_weekend(date)", :observed_arguments => [:date], :name => "Latvijas Republikas Proklamēšanas diena", :regions => [:lv]}],
      12 => [{:mday => 24, :name => "Ziemassvētku vakars", :regions => [:lv]},
            {:mday => 25, :name => "Pirmie Ziemassvētki", :regions => [:lv]},
            {:mday => 26, :name => "Otrie Ziemassvētki", :regions => [:lv]},
            {:mday => 31, :name => "Vecgada diena", :regions => [:lv]}]
      }
    end

    def self.custom_methods
      {
          "lv_song_and_dance_festival_end_date(year)" => Proc.new { |year|
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
},


      }
    end
  end
end
