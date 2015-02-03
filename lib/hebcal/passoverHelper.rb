require 'hebcal/constants'

module HebCal
  module PassoverHelper
    def PassoverHelper.IsLeapYear year
      [3,6,8,11,14,17,19].include? (year % 19)
    end

    def PassoverHelper.PrecedesLeapYear year
      IsLeapYear(year+1)
    end

    def PassoverHelper.CalculateMolad yearH
      _HPD = PassoverConstants::HALAKIM_PER_DAY
      _LC = PassoverConstants::LUNAR_CYCLE

      year_in_julian_cycle = yearH % 4
      drift_since_epoch = (_LC + PassoverConstants::EPOCH_TEKUFAH + (_LC - PassoverConstants::ANNUAL_DRIFT) * (yearH % 19) - _HPD) % _LC

      _LC + _HPD + PassoverConstants::MOLAD_ZAQEN + drift_since_epoch + (year_in_julian_cycle * PassoverConstants::JULIAN_ANNUAL_CALENDAR_DRIFT) - (PassoverConstants::JULIAN_ERROR_PER_19_YEAR_CYCLE * (yearH / 19).floor)
    end
  end
end