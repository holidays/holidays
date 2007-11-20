
# === References
# ==== Calculations
# * http://michaelthompson.org/technikos/holidays.php
# ==== World
# * http://en.wikipedia.org/wiki/List_of_holidays_by_country
# ==== US
# * http://www.opm.gov/Operating_Status_Schedules/fedhol/index.asp
# * http://www.smart.net/~mmontes/ushols.html
module Holidays
  # Exception class for dealing with unknown regions.
  class UnkownRegionError < StandardError; end

  VERSION = '1.0.0'

  HOLIDAY_REGIONS = {:ca => 'Canada', :us => 'United States'}
  WEEKS = {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :last => -1}
  MONTH_LENGTHS = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]


  # :wday: Day of the week (0 is Sunday, 6 is Saturday)
  HOLIDAYS_BY_MONTH = {
   1  => [{:mday => 1,  :name => 'New Year\'s Day', :regions => [:us, :ca]},
          {:mday => 6,  :name => 'Epiphany Day', :regions => [:gr]},
          {:wday => 1,  :week => :third, :name => 'Martin Luther King, Jr. Day', :regions => [:us]}],
   3  => [{:wday => 1,  :week => :third, :name => 'George Washington\'s Birthday', :regions => [:us]},
          {:mday => 25,  :name => 'Independence Day', :regions => [:gr]}],
   5  => [{:mday => 1,  :name => 'Labour Day', :regions => [:fr,:gr]},
          {:mday => 8,  :name => 'Victoria 1945', :regions => [:fr]},
          {:wday => 6,  :week => :third, :name => 'Armed Forces Day', :regions => [:us]},
          {:wday => 1,  :week => :last, :name => 'Memorial Day', :regions => [:us]}],
   6  => [{:mday => 14, :name => 'Flag Day', :regions => [:us]}],
   7  => [{:mday => 4,  :name => 'Independence Day', :regions => [:us]},
          {:mday => 14,  :name => 'Ascension Day', :regions => [:fr]}],
   8 =>  [{:mday => 15,  :name => 'Assumption of Mary', :regions => [:fr, :gr, :christ]}],
   9  => [{:wday => 1,  :week => :first,:name => 'Labor Day', :regions => [:us]},
          {:wday => 1,  :week => :first,:name => 'Labour Day', :regions => [:ca]}],
   10 => [{:wday => 1,  :week => :second, :name => 'Columbus Day', :regions => [:us]},
          {:mday => 28,  :name => 'National Day', :regions => [:gr]}],
   11 => [{:wday => 4,  :week => :fourth, :name => 'Thanksgiving Day', :regions => [:us]},
          {:mday => 11, :name => 'Rememberance Day', :regions => [:ca]},
          {:mday => 11, :name => 'Armistice 1918', :regions => [:fr]},
          {:mday => 1, :name => 'Touissant', :regions => [:fr]}],
   12 => [{:mday => 25, :name => 'Christmas Day', :regions => [:us,:ca,:christ]},
          {:mday => 26, :name => 'Boxing Day', :regions => [:ca,:gr]}]
  }

  # Get all holidays on a certain date
  def self.lookup_holidays(date, regions = [:ca, :us])
    #raise(UnkownRegionError, "No holiday information is available for region '#{region}'") unless known_region?(region)

    regions = [regions] unless regions.kind_of?(Array)
    hbm = HOLIDAYS_BY_MONTH[date.mon]
     
    holidays = []

    year = date.year
    month = date.month
    mday = date.mday
    wday = date.wday

    hbm.each do |h|
      # start with the region check
      next unless h[:regions].any?{ |reg| regions.include?(reg) }
      
      if h[:mday] and h[:mday] == mday
        # fixed day of the month
        holidays << h
      elsif h[:wday] == wday
        # by week calculation
        if calculate_mday(year, month, h[:week], h[:wday]) == mday
          holidays << h
        end
      end
    end

    holidays
  end

  #def self.calculate_mday(yr, mo, wday, int)
  #  earliest = 1 + 7 * (int - 1)

  #  wd = Date.civil(yr, mo, earliest).wday
  #  if wday == earliest
  #    off = 0
  #  else
  #    if wday < wd
  #      off = wday + (7 - wd)
  #    else
  #      off = (wday + (7 - wd)) - 7
  #    end
  #  end

  #  earliest + off
 # end

  # Calculate the day of the month based on week and day of the week.
  #
  # First Monday of Jan, 2008
  #   calculate_mday(2008, 1, :first, :monday)
  #
  # Third Thursday of Dec, 2008
  #   calculate_mday(2008, 12, :third, 4)
  #
  # Last Monday of Jan, 2008
  #   calculate_mday(2008, 1, :last, 1)
  #--
  # see http://www.irt.org/articles/js050/index.htm
  def self.calculate_mday(year, month, week, wday)
    raise ArgumentError, "Week paramater must be one of Holidays::WEEKS" unless WEEKS.include?(week)

    nth = WEEKS[week]

    if nth > 0
      return (nth-1)*7 + 1 + (7 + wday - Date.civil(year, month,(nth-1)*7 + 1).wday)%7
    end
    
    days = MONTH_LENGTHS[month]
    if month == 2 and Date.civil(year,1,1).leap?
      days = 29
    end

    return days - (Date.civil(year, month, days).wday - wday + 8)%7;
  end

  def self.holidays_in_range(from, to, regions = [:ca,:us])
    regions = [regions] unless regions.kind_of?(Array)
    holidays = []



  end
end

class Date
  include Holidays

  # Date.civil('2008-01-01').is_holiday?(:us)
  def is_holiday?(region = 'us')
    region = region.to_sym

    holidays = Holidays.lookup_holidays(self, region)
    if holidays
      return true
    else
      return false
    end
  end
end