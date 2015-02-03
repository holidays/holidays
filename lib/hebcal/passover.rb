require 'hebcal/constants'
require 'hebcal/passoverHelper'

module HebCal
  module Passover
    def Passover.WhenIsPesach yearG
      _HPD = PassoverConstants::HALAKIM_PER_DAY
      _MZ = PassoverConstants::MOLAD_ZAQEN

      # CALCULATE MOLAD
      yearH = yearG + 3760
      year_in_julian_cycle = yearG % 4
      molad = PassoverHelper::CalculateMolad yearH
      halakim_into_day = molad % _HPD

      # CALCULATE CALENDAR DATE OF PESACH
      gregorian_divergence = (yearG/100).floor - (yearG/400).floor - 2
      pesach_julian_day = (molad - halakim_into_day) / _HPD

      day_of_week = ((3 * yearG) + (5 * year_in_julian_cycle) + pesach_julian_day) % 7
      pesach_day = pesach_julian_day + gregorian_divergence

      if [1,3,5].include? day_of_week then
        pesach_day += 1
      elsif (0 == day_of_week && !PassoverHelper::PrecedesLeapYear(yearH) && halakim_into_day >= PassoverConstants::TARAD + _MZ)
        pesach_day += 2
      elsif (6 == day_of_week && PassoverHelper::IsLeapYear(yearH) && halakim_into_day >= PassoverConstants::TUTAKPAT + _MZ)
        pesach_day += 1
      end

      pesach_month = 3

      pesach = Time.new(yearG, pesach_month, 1) + (pesach_day - 1) * 24 * 60 * 60
      pesach = pesach.dst? ? pesach - 60 * 60 : pesach
    end
  end
end