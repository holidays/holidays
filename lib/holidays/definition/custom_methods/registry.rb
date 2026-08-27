require 'holidays/definition/custom_methods/ar'
require 'holidays/definition/custom_methods/au'
require 'holidays/definition/custom_methods/ca'
require 'holidays/definition/custom_methods/ch'
require 'holidays/definition/custom_methods/cn'
require 'holidays/definition/custom_methods/cl'
require 'holidays/definition/custom_methods/co'
require 'holidays/definition/custom_methods/de'
require 'holidays/definition/custom_methods/fedex'
require 'holidays/definition/custom_methods/fi'
require 'holidays/definition/custom_methods/ie'
require 'holidays/definition/custom_methods/is'
require 'holidays/definition/custom_methods/jp'
require 'holidays/definition/custom_methods/kr'
require 'holidays/definition/custom_methods/lv'
require 'holidays/definition/custom_methods/nz'
require 'holidays/definition/custom_methods/ph'
require 'holidays/definition/custom_methods/se'
require 'holidays/definition/custom_methods/tr'
require 'holidays/definition/custom_methods/us'

module Holidays
  module Definition
    module CustomMethods
      # Maps the full call-signature string used by YAML +function:+/+observed:+
      # references to the native proc that implements it. Seeded into
      # Factory::Definition.custom_methods_repository at boot by
      # LoadAllDefinitions.call, alongside the global built-in methods.
      #
      # Native replacement for the old per-region +methods:/ruby:+ YAML blocks.
      # No eval, no public registration API.
      #
      # ca_victoria_day and day_after_thanksgiving each have byte-identical
      # duplicates in other region YAML files; hosted once here and shared.
      def self.all
        {
          "afl_grand_final(year)" => AU.method(:afl_grand_final).to_proc,
          "ca_victoria_day(year)" => CA.method(:ca_victoria_day).to_proc,
          "ch_be_zibelemaerit(year)" => CH.method(:ch_be_zibelemaerit).to_proc,
          "ch_ge_jeune_genevois(year)" => CH.method(:ch_ge_jeune_genevois).to_proc,
          "ch_gl_naefelser_fahrt(year)" => CH.method(:ch_gl_naefelser_fahrt).to_proc,
          "ch_vd_lundi_du_jeune_federal(year)" => CH.method(:ch_vd_lundi_du_jeune_federal).to_proc,
          "christmas_eve_holiday(date)" => US.method(:christmas_eve_holiday).to_proc,
          "closest_monday(date)" => NZ.method(:closest_monday).to_proc,
          "cn_qingming(year)" => CN.method(:cn_qingming).to_proc,
          "columbus_day_cl(year)" => CL.method(:columbus_day_cl).to_proc,
          "day_after_thanksgiving(year)" => FEDEX.method(:day_after_thanksgiving).to_proc,
          "de_buss_und_bettag(year)" => DE.method(:de_buss_und_bettag).to_proc,
          "election_day(year)" => US.method(:election_day).to_proc,
          "even_year_election_day(year)" => US.method(:even_year_election_day).to_proc,
          "fi_juhannusaatto(year)" => FI.method(:fi_juhannusaatto).to_proc,
          "fi_juhannuspaiva(year)" => FI.method(:fi_juhannuspaiva).to_proc,
          "fi_pyhainpaiva(year)" => FI.method(:fi_pyhainpaiva).to_proc,
          "georgia_state_holiday(year, month)" => US.method(:georgia_state_holiday).to_proc,
          "hobart_show_day(year)" => AU.method(:hobart_show_day).to_proc,
          "ie_st_brigids_day(year)" => IE.method(:ie_st_brigids_day).to_proc,
          "is_sumardagurinn_fyrsti(year)" => IS.method(:is_sumardagurinn_fyrsti).to_proc,
          "jp_citizens_holiday(year)" => JP.method(:jp_citizens_holiday).to_proc,
          "jp_health_sports_day_substitute(year)" => JP.method(:jp_health_sports_day_substitute).to_proc,
          "jp_marine_day_substitute(year)" => JP.method(:jp_marine_day_substitute).to_proc,
          "jp_mountain_holiday(year)" => JP.method(:jp_mountain_holiday).to_proc,
          "jp_mountain_holiday_substitute(year)" => JP.method(:jp_mountain_holiday_substitute).to_proc,
          "jp_national_culture_day(year)" => JP.method(:jp_national_culture_day).to_proc,
          "jp_national_culture_day_substitute(year)" => JP.method(:jp_national_culture_day_substitute).to_proc,
          "jp_next_weekday(date)" => JP.method(:jp_next_weekday).to_proc,
          "jp_respect_for_aged_holiday_substitute(year)" => JP.method(:jp_respect_for_aged_holiday_substitute).to_proc,
          "jp_substitute_holiday(year, month, day)" => JP.method(:jp_substitute_holiday).to_proc,
          "jp_vernal_equinox_day(year)" => JP.method(:jp_vernal_equinox_day).to_proc,
          "jp_vernal_equinox_day_substitute(year)" => JP.method(:jp_vernal_equinox_day_substitute).to_proc,
          "juneteenth_national_independence_day(region, date)" => US.method(:juneteenth_national_independence_day).to_proc,
          "kr_seollal_eve(year, region)" => KR.method(:kr_seollal_eve).to_proc,
          "lee_jackson_day(year, month)" => US.method(:lee_jackson_day).to_proc,
          "lv_song_and_dance_festival_end_date(year)" => LV.method(:lv_song_and_dance_festival_end_date).to_proc,
          "march_pub_hol_sa(year)" => AU.method(:march_pub_hol_sa).to_proc,
          "matariki(year)" => NZ.method(:matariki).to_proc,
          "may_pub_hol_sa(year)" => AU.method(:may_pub_hol_sa).to_proc,
          "next_week(date)" => NZ.method(:next_week).to_proc,
          "nz_canterbury_anniversary(year)" => NZ.method(:nz_canterbury_anniversary).to_proc,
          "other_churches_day_cl(year)" => CL.method(:other_churches_day_cl).to_proc,
          "ph_heroes_day(year)" => PH.method(:ph_heroes_day).to_proc,
          "previous_friday(date)" => NZ.method(:previous_friday).to_proc,
          "qld_brisbane_ekka_holiday(year)" => AU.method(:qld_brisbane_ekka_holiday).to_proc,
          "qld_kings_bday_october(year)" => AU.method(:qld_kings_bday_october).to_proc,
          "qld_labour_day_may(year)" => AU.method(:qld_labour_day_may).to_proc,
          "qld_labour_day_october(year)" => AU.method(:qld_labour_day_october).to_proc,
          "qld_queens_bday_october(year)" => AU.method(:qld_queens_bday_october).to_proc,
          "qld_queens_birthday_june(year)" => AU.method(:qld_queens_birthday_june).to_proc,
          "ramadan_feast(year)" => TR.method(:ramadan_feast).to_proc,
          "rosh_hashanah(year)" => US.method(:rosh_hashanah).to_proc,
          "sacrifice_feast(year)" => TR.method(:sacrifice_feast).to_proc,
          "se_alla_helgons_dag(year)" => SE.method(:se_alla_helgons_dag).to_proc,
          "se_midsommardagen(year)" => SE.method(:se_midsommardagen).to_proc,
          "st_peter_st_paul_cl(year)" => CL.method(:st_peter_st_paul_cl).to_proc,
          "to_following_monday_if_not_monday(date)" => CO.method(:to_following_monday_if_not_monday).to_proc,
          "to_nearest_monday(date)" => AR.method(:to_nearest_monday).to_proc,
          "to_nearest_monday_after(date)" => AU.method(:to_nearest_monday_after).to_proc,
          "us_inauguration_day(year)" => US.method(:us_inauguration_day).to_proc,
          "yom_kippur(year)" => US.method(:yom_kippur).to_proc,
        }
      end
    end
  end
end
