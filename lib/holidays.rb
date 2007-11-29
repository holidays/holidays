$:.unshift File.dirname(__FILE__)

require 'digest/md5'

# === Ruby Holidays module
#
# ==== Using regions
# Holidays can be defined as belonging to one or more regions and sub regions.
# The Holidays#on, Holidays#between, Date#holidays and Date#holiday? methods
# each allow you to specify a specific region.
#
# There are several different ways that you can specify a region:
#
# ca::       By region. Return holidays in the CA region (Canada).
# ca_::      By region and sub regions. Return holidays in the CA region and all sub regions.
#
# ca_bc::    By sub region.     Return holidays in the CA region and CA_BC sub region.
# any::    Any region.  Return holidays from any region.
module Holidays
  # Exception thrown when an unknown region is requested.
  class UnkownRegionError < ArgumentError; end

  VERSION = '0.9.0'

  @@regions = []
  @@holidays_by_month = {}
  @@proc_cache = {}

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
  # [<tt>:date</tt>]    Ruby Date object.
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
        next unless hbm = @@holidays_by_month[month]
        hbm.each do |h|
          next unless in_region?(regions, h[:regions])
          
          if h[:function]
            result = call_proc(h[:function], year)
            if result.kind_of?(Date)
              month = result.month
              mday = result.mday
            else
              day = result
            end
          else
            mday = h[:mday] || Date.calculate_mday(year, month, h[:week], h[:wday])
          end

          begin
            date = Date.new(year, month, mday)
          rescue; next; end

          if date.between?(start_date, end_date)
            holidays << {:date => date, :name => h[:name], :regions => h[:regions]}
          end

        end
      end
    end

    holidays
  end

  # Merge a new set of definitions into the Holidays module.
  #
  # This method is automatically called when including holiday definition
  # files.
  def self.merge_defs(regions, holidays) # :nodoc:
    @@regions = @@regions | regions
    @@regions.uniq!
    
    holidays.each do |month, holiday_defs|
      @@holidays_by_month[month] = [] unless @@holidays_by_month[month]
      holiday_defs.each do |holiday_def|

          exists = false
          @@holidays_by_month[month].each do |ex|
            
            if ex[:name] == holiday_def[:name] and ex[:wday] == holiday_def[:wday] and ex[:mday] == holiday_def[:mday] and ex[:week] == holiday_def[:week] and ex[:function_id] == holiday_def[:function_id]
            
              # append regions
              ex[:regions] << holiday_def[:regions]
              
              # Should do this once we're done
              ex[:regions].flatten!
              ex[:regions].uniq!
              exists = true
            end            
          end
          
          
          
          unless exists            
            @@holidays_by_month[month] << holiday_def 
            if holiday_def[:function]
              #puts "New func #{holiday_def[:function].methods.join(', ')}"
#              puts "New func #{holiday_def[:function]  }"
             end
         end
      end
    end
  end

  # Get the date of Easter Sunday in a given year.  From Easter Sunday, it is
  # possible to calculate many traditional holidays in Western countries.
  #
  # +year+ must be a valid Gregorian year.
  #
  # Returns a Date object.
  #--
  # from http://snippets.dzone.com/posts/show/765
  # TODO: check year to ensure Gregorian
  def self.easter(year)
    y = year
    a = y % 19
    b = y / 100
    c = y % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = (19 * a + b - d - g + 15) % 30
    i = c / 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) / 451
    month = (h + l - 7 * m + 114) / 31
    day = ((h + l - 7 * m + 114) % 31) + 1
    Date.civil(year, month, day)
  end



private
  # Check regions against list of supported regions and return an array of 
  # symbols.
  #
  # If a wildcard region is found (e.g. <tt>:ca_</tt>) it is expanded into all
  # of its available sub regions.
  def self.validate_regions(regions) # :nodoc:
    regions = [regions] unless regions.kind_of?(Array)
    regions = regions.collect { |r| r.to_sym }

    # Found sub region wild-card
    regions.delete_if do |reg|
      if reg.to_s =~ /_$/
        regions << @@regions.select { |dr| dr.to_s =~ Regexp.new("^#{reg}") }
        true
      end
    end

    regions.flatten!

    raise UnkownRegionError unless regions.all? { |r| r == :any or @@regions.include?(r) }

    regions
  end

  # Check sub regions.
  #
  # When request :any, all holidays should be returned.
  # When requesting :ca_bc, holidays in :ca or :ca_bc should be returned.
  # When requesting :ca, holidays in :ca but not its subregions should be returned.
  def self.in_region?(requested, available) # :nodoc:
    return true if requested.include?(:any)
    
    # When an underscore is encountered, derive the parent regions
    # symbol and include both in the requested array.
    requested = requested.collect do |r|
      r.to_s =~ /_/ ? [r, r.to_s.gsub(/_[\w]*$/, '').to_sym] : r
    end

    requested = requested.flatten.uniq

    available.any? { |avail| requested.include?(avail) }
  end

  # Call a proc function defined in a holiday definition file.
  #
  # Procs are cached.
  #
  # ==== Benchmarks
  #
  # Lookup Easter Sunday, with caching, by number of iterations:
  # 
  #       user     system      total        real
  # 0001  0.000000   0.000000   0.000000 (  0.000000)
  # 0010  0.000000   0.000000   0.000000 (  0.000000)
  # 0100  0.078000   0.000000   0.078000 (  0.078000)
  # 1000  0.641000   0.000000   0.641000 (  0.641000)
  # 5000  3.172000   0.015000   3.187000 (  3.219000)
  # 
  # Lookup Easter Sunday, without caching, by number of iterations:
  # 
  #       user     system      total        real
  # 0001  0.000000   0.000000   0.000000 (  0.000000)
  # 0010  0.016000   0.000000   0.016000 (  0.016000)
  # 0100  0.125000   0.000000   0.125000 (  0.125000)
  # 1000  1.234000   0.000000   1.234000 (  1.234000)
  # 5000  6.094000   0.031000   6.125000 (  6.141000)
  def self.call_proc(function, year) # :nodoc:
    proc_key = Digest::MD5.hexdigest("#{function.to_s}_#{year.to_s}")
    @@proc_cache[proc_key] = function.call(year) unless @@proc_cache[proc_key]
    @@proc_cache[proc_key]
  end
end

# === Extending Ruby's Date class with the Holidays gem
# The Holidays gem automatically extends Ruby's Date class and gives you access
# to three new methods: holiday?, #holidays and #calculate_mday.
#
# ==== Examples
# Lookup Canada Day in the <tt>:ca</tt> region
#   Date.civil(2008,7,1).holiday?(:ca)
#   => true
#
# Lookup Canada Day in the <tt>:fr</tt> region
#   Date.civil(2008,7,1).holiday?(:fr)
#   => false
#
# Lookup holidays in North America in January 1.
#   Date.civil(2008,1,1).holidays([:ca, :mx, :us])
#   => [{:name => 'New Year\'s Day'...}]
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
  # [<tt>year</tt>]  Integer.
  # [<tt>month</tt>] Integer from 1-12.
  # [<tt>week</tt>]  One of <tt>:first</tt>, <tt>:second</tt>, <tt>:third</tt>,
  #                  <tt>:fourth</tt> or <tt>:fifth</tt>.
  # [<tt>wday</tt>]  Day of the week as an integer from 0 (Sunday) to 6
  #                  (Saturday) or as a symbol (e.g. <tt>:monday</tt>).
  #
  # Returns an integer.
  #
  # ===== Examples
  # First Monday of January, 2008:
  #   calculate_mday(2008, 1, :first, :monday)
  #   => 7
  #
  # Third Thursday of December, 2008:
  #   calculate_mday(2008, 12, :third, 4)
  #   => 18
  #
  # Last Monday of January, 2008:
  #   calculate_mday(2008, 1, :last, 1)
  #   => 28
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