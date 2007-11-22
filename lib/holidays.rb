$:.unshift File.dirname(__FILE__)

module Holidays
  # Exception thrown when an unknown region is requested.
  class UnkownRegionError < ArgumentError; end

  VERSION = '0.9.0'

  WEEKS = {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :last => -1}
  MONTH_LENGTHS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  #--
  #HOLIDAYS_TYPES = [:bank, :statutory, :religious, :informal]
  #++

  # Get all holidays on a given date.
  #
  # [<tt>date</tt>]    A Date object.
  # [<tt>regions</tt>] A symbol (e.g. <tt>:ca</tt>) or an array of symbols 
  #                    (e.g. <tt>[:ca, :ca_bc, :us]</tt>).
  #
  # Returns an array of hashes or nil. See Holidays#between for the output 
  # format.
  #
  # Also available via Date#holidays.
  def self.on(date, regions = :any)
    self.between(date, date, regions)
  end

  # Get all holidays occuring between two dates, inclusively.
  #
  # Returns an array of hashes or nil.
  #
  # Each holiday is returned as a hash with the following fields:
  # [<tt>:year</tt>]    Integer.
  # [<tt>:month</tt>]   Integer.
  # [<tt>:day</tt>]     Integer.
  # [<tt>:name</tt>]    String.
  # [<tt>:regions</tt>] An array of region symbols.
  #--
  # [<tt>:types</tt>]   An array of holiday-type symbols.
  def self.between(start_date, end_date, regions = :any)
    regions = validate_regions(regions)
    holidays = []

    dates = {}
    (start_date..end_date).each do |date|
      # Always include month '0' for variable-month holidays
      dates[date.year] = [0] unless dates[date.year]      
      # TODO: test this, maybe should push then flatten
      dates[date.year] << date.month unless dates[date.year].include?(date.month)
    end

    dates.each do |year, months|
      months.each do |month|
        next unless hbm = HOLIDAYS_BY_MONTH[month]
        hbm.each do |h|
          next unless in_region?(regions, h[:regions])
          
          if h[:function]
            result = h[:function].call(year)
            if result.kind_of?(Date)
              month = result.month
              mday = result.mday
            else
              day = result
            end
          else
            mday = h[:mday] || Date.calculate_mday(year, month, h[:week], h[:wday])
          end

          if Date.new(year, month, mday).between?(start_date, end_date)
            holidays << {:month => month, :day => mday, :year => year, :name => h[:name], :regions => h[:regions]}
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

  # Check sub regions.
  #
  # When request :any, all holidays should be returned.
  # When requesting :ca_bc, holidays in :ca or :ca_bc should be returned.
  # When requesting :ca, only holidays in :ca should be returned.
  def self.in_region?(requested, available) # :nodoc:
    return true if requested.include?(:any)
    
    # When an underscore is encountered, derive the parent regions
    # symbol and include both in the requested array.
    requested = requested.collect do |r|
      r.to_s =~ /_/ ? [r, r.to_s.gsub(/_[\w]*$/, '').to_sym] : r
    end

    requested = requested.flatten.uniq

    available.any? { |r| requested.include?(r) }
  end
end


class Date
  include Holidays

  # Get holidays on the current date.
  #
  # Returns an array of hashes or nil. See Holidays#between for the output 
  # format.
  #
  #   Date.civil('2008-01-01').holidays(:ca)
  #   => [{:name => 'Canada Day',...}]
  #
  # Also available via Holidays#on.
  def holidays(regions = :any)
    Holidays.on(self, regions)
  end

  # Check if the current date is a holiday.
  #
  # Returns an array of hashes or nil. See Holidays#between for the output 
  # format.
  #
  #   Date.civil('2008-01-01').holiday?(:ca)
  #   => true
  def holiday?(regions = :any)
    holidays = self.holidays(regions)
    holidays && !holidays.empty?
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
    raise ArgumentError, "Week parameter must be one of Holidays::WEEKS (provided #{week})." unless WEEKS.include?(week) or WEEKS.has_value?(week)

    week = WEEKS[week] if week.kind_of?(Symbol)

    # :first, :second, :third, :fourth or :fifth
    if week > 0
      return ((week - 1) * 7) + 1 + ((7 + wday - Date.civil(year, month,(week-1)*7 + 1).wday) % 7)
    end
    
    days = MONTH_LENGTHS[month-1]

    days = 29 if month == 1 and Date.civil(year,1,1).leap?
      
    return days - ((Date.civil(year, month, days).wday - wday + 7) % 7)
  end



end