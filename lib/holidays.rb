$:.unshift File.dirname(__FILE__)
require 'holidays/easter'

module Holidays
  # Exception thrown when an unknown region is encountered.
  class UnkownRegionError < ArgumentError; end

  self.extend Easter

  VERSION = '0.9.0'

  WEEKS = {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :last => -1}
  MONTH_LENGTHS = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  DEFINED_REGIONS = [:us, :au]
  HOLIDAYS_TYPES = [:bank, :statutory, :religious, :informal]


  # :wday  Day of the week (0 is Sunday, 6 is Saturday)
  # :function Can return an integer representing mday or a Date object.
  #
  # The month <tt>0</tt> is used to store events that require lambda calculations
  # and may occur in more than one month.
  HOLIDAYS_BY_MONTH = {
   1  => [{:mday => 1,  :name => 'New Year\'s Day', :regions => [:ca, :au]},
          {:mday => 1,  :name => 'Australia Day', :regions => [:au]}]
  }



  # Get all holidays on a given date.
  #
  # [<tt>date</tt>]    A Date object.
  # [<tt>regions</tt>] A symbol (e.g. <tt>:ca</tt>) or an array of symbols 
  #                    (e.g. <tt>[:ca, :ca_bc, :us]</tt>).
  #
  # Returns an array of hashes or nil.
  #
  # Each holiday is returned as a hash with the following fields:
  # [<tt>:year</tt>]    Integer.
  # [<tt>:month</tt>]   Integer.
  # [<tt>:day</tt>]     Integer.
  # [<tt>:name</tt>]    String.
  # [<tt>:regions</tt>] An array of region symbols.
  # [<tt>:types</tt>]   An array of holiday-type symbols.
  def self.by_day(date, regions = [:ca, :us])
    regions = validate_regions(regions)

    hbm = HOLIDAYS_BY_MONTH.values_at(0,date.mon).flatten
     
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
        if Date.calculate_mday(year, month, h[:week], h[:wday]) == mday
          holidays << h
        end
      elsif h[:function]
        result = h[:function].call(year)
        if result.kind_of?(Date) and result.mon == month and result.mday == mday
          holidays << h
        elsif result == mday
          holidays << h
        end
      
      end
    end
    holidays
  end

  # Get all holidays occuring between two dates, inclusively.
  #
  # Returns an array of hashes or nil.  See Holidays#by_day for the output 
  # format.
  #--
  # TODO: do not take full months
  def self.between(start_date, end_date, regions = [:ca,:us])
    regions = validate_regions(regions)
    holidays = []

    dates = {}
    (start_date..end_date).each do |date|
      dates[date.year] = Array.new unless dates[date.year]      
      # TODO: test this, maybe should push then flatten
      dates[date.year] << date.month unless dates[date.year].include?(date.month)
    end

    dates.each do |year, months|
      months.each do |month|
        next unless hbm = HOLIDAYS_BY_MONTH[month]
        hbm.each do |h|
          next unless h[:regions].any?{ |reg| regions.include?(reg) }
          
          if h[:function]
            result = h[:function].call(year)
            if result.kind_of?(Date) and result.mon == month
              holidays << h.merge({:day => result.mday})
            else  #if result == mday
              holidays << h
            end


          else
            day = h[:mday] || Date.calculate_mday(year, month, h[:week], h[:wday])
            holidays << {:month => month, :day => day, :year => year, :name => h[:name], :regions => h[:regions]}
          end
        end
      end
    end

    holidays
  end

private
  # Check regions against list of supported regions and return an array of 
  # symbols.
  def self.validate_regions(regions) # :nodoc:
    regions = [regions] unless regions.kind_of?(Array)
    regions = regions.collect { |r| r.to_sym }

    raise UnkownRegionError unless regions.all? { |r| r == :any or DEFINED_REGIONS.include?(r) }

    regions
  end

end


class Date
  include Holidays

  # Check if the current date is a holiday in a given region.
  #
  #   Date.civil('2008-01-01').is_holiday?(:ca)
  #   => true
  def is_holiday?(regions = :any)
    holidays = Holidays.by_day(self, regions)
    !holidays.empty?
  end

  # Calculate day of the month based on the week number and the day of the 
  # week.
  #
  # ==== Parameters
  # [<tt>year</tt>] Integer.
  # [<tt>month</tt>] Integer from 1-12.
  # [<tt>week</tt>] One of <tt>:first</tt>, <tt>:second</tt>, <tt>:third</tt>,
  #                 <tt>:fourth</tt> or <tt>:fifth</tt>.
  # [<tt>wday</tt>] Day of the week as an integer from 0 (Sunday) to 6
  #                 (Saturday) or as a symbol (e.g. <tt>:monday</tt>).
  #
  # Returns an integer.
  #
  # ===== Examples
  # First Monday of January, 2008:
  #   calculate_mday(2008, 1, :first, :monday)
  #
  # Third Thursday of December, 2008:
  #   calculate_mday(2008, 12, :third, 4)
  #
  # Last Monday of January, 2008:
  #   calculate_mday(2008, 1, :last, 1)
  #--
  # see http://www.irt.org/articles/js050/index.htm
  def self.calculate_mday(year, month, week, wday)
    raise ArgumentError, "Week parameter must be one of Holidays::WEEKS (provided #{week})." unless WEEKS.include?(week)

    week = WEEKS[week]

    # :first, :second, :third, :fourth or :fifth
    if week > 0
      return ((week - 1) * 7) + 1 + ((7 + wday - Date.civil(year, month,(week-1)*7 + 1).wday) % 7)
    end
    
    days = MONTH_LENGTHS[month-1]
    if month == 1 and Date.civil(year,1,1).leap?
      days = 29
    end

    return days - ((Date.civil(year, month, days).wday - wday + 7) % 7)
  end



end