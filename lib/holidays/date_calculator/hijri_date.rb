require 'date'

module Holidays
  module DateCalculator
    # Arithmetic ("tabular", a.k.a. Kuwaiti) Islamic calendar.
    #
    # Months alternate 30 and 29 days; leap years add a day to the twelfth
    # month on a fixed 11-of-30 cycle. This is a purely arithmetic calendar,
    # so it can land a day (occasionally two) either side of a locally
    # proclaimed date. Callers that need the proclaimed date layer their own
    # override table on top of this (see
    # Holidays::Definition::CustomMethods::TR).
    class HijriDate
      # Julian day number of 1 Muharram 1 AH minus one day, chosen so that
      # to_jd's month/day terms are added directly. Corresponds to the civil
      # epoch (Friday, 16 July 622 CE proleptic Julian).
      EPOCH_JDN = 1948439

      def to_gregorian(hijri_year, hijri_month, hijri_day)
        Date.jd(to_jd(hijri_year, hijri_month, hijri_day))
      end

      # Given a Gregorian year and a fixed Hijri month/day, return the
      # occurrence that falls within that Gregorian year, or nil if none does.
      #
      # A fixed Hijri date drifts ~11 days earlier each Gregorian year, so
      # roughly once every 33 years it falls twice in the same Gregorian year
      # (once in early January, once in late December). Only the earlier
      # occurrence is returned.
      def gregorian_year_occurrence(gregorian_year, hijri_month, hijri_day)
        candidate_hijri_year = gregorian_year - 579

        (candidate_hijri_year - 1..candidate_hijri_year + 1).each do |hijri_year|
          date = to_gregorian(hijri_year, hijri_month, hijri_day)
          return date if date.year == gregorian_year
        end

        nil
      end

      private

      def to_jd(year, month, day)
        day +
          (29.5 * (month - 1)).ceil +
          (year - 1) * 354 +
          (3 + 11 * year) / 30 +
          EPOCH_JDN
      end
    end
  end
end
