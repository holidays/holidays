# encoding: utf-8
$:.unshift File.dirname(__FILE__)

require 'digest/md5'
require 'date'
require 'hebcal/passover'

# == Region options
# Holidays can be defined as belonging to one or more regions and sub regions.
# The Holidays#on, Holidays#between, Date#holidays and Date#holiday? methods
# each allow you to specify a specific region.
#
# There are several different ways that you can specify a region:
#
# [<tt>:region</tt>]
#   By region. For example, return holidays in the Canada with <tt>:ca</tt>.
# [<tt>:region_</tt>]
#   By region and sub regions. For example, return holidays in Germany
#   and all its sub regions with <tt>:de_</tt>.
# [<tt>:region_sub</tt>]
#   By sub region. Return national holidays in Spain plus holidays in Spain's
#   Valencia region with <tt>:es_v</tt>.
# [<tt>:any</tt>]
#   Any region.  Return holidays from any loaded region.
#
#
# You can load all the available holiday definition sets by running
#   Holidays.load_all
# == Other options
# [<tt>:observed</tt>]    Return holidays on the day they are observed (e.g. on a Monday if they fall on a Sunday).
# [<tt>:informal</tt>]    Include informal holidays (e.g. Valentine's Day)
#
# == Examples
# Return all holidays in the <tt>:ca</tt> and <tt>:us</tt> regions on the day that they are
# observed.
#
#   Holidays.between(from, to, :ca, :us, :observed)
#
# Return all holidays in <tt>:ca</tt> and any <tt>:ca</tt> sub-region.
#
#   Holidays.between(from, to, :ca_)
#
# Return all holidays in <tt>:ca_bc</tt> sub-region (which includes the <tt>:ca</tt>), including informal holidays.
#
#   Holidays.between(from, to, :ca_bc, :informal)
module Holidays
  # Exception thrown when an unknown region is requested.
  class UnknownRegionError < ArgumentError; end

  @@regions = []
  @@holidays_by_month = {}
  @@proc_cache = {}

  WEEKS = {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :last => -1, :second_last => -2, :third_last => -3}
  MONTH_LENGTHS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  DAY_SYMBOLS = Date::DAYNAMES.collect { |n| n.downcase.intern }
  DEFINITION_PATH = File.expand_path(File.dirname(__FILE__) + '/holidays/')

  # Get all holidays on a given date.
  #
  # [<tt>date</tt>]     A Date object.
  # [<tt>:options</tt>] One or more region symbols, <tt>:informal</tt> and/or <tt>:observed</tt>.
  #
  # Returns an array of hashes or nil. See Holidays#between for the output
  # format.
  #
  # Also available via Date#holidays.
  def self.on(date, *options)
    self.between(date, date, options)
  end

  # Does the given work-week have any holidays?
  #
  # [<tt>date</tt>]   A Date object.
  # [<tt>:options</tt>] One or more region symbols, and/or <tt>:informal</tt>. Automatically includes <tt>:observed</tt>. If you don't want this, pass <tt>:no_observed</tt>
  #
  # The given Date can be any day of the week.
  # Returns true if any holidays fall on Monday - Friday of the given week.
  def self.full_week?(date, *options)
    days_to_monday = date.wday - 1
    days_to_friday = 5 - date.wday
    start_date = date - days_to_monday
    end_date = date + days_to_friday
    options += [:observed] unless options.include?(:no_observed)
    options.delete(:no_observed)
    self.between(start_date, end_date, options).empty?
  end

  # Get all holidays occuring between two dates, inclusively.
  #
  # Returns an array of hashes or nil.
  #
  # Each holiday is returned as a hash with the following fields:
  # [<tt>start_date</tt>]  Ruby Date object.
  # [<tt>end_date</tt>]    Ruby Date object.
  # [<tt>options</tt>]     One or more region symbols, <tt>:informal</tt> and/or <tt>:observed</tt>.
  #
  # ==== Example
  #   from = Date.civil(2008,7,1)
  #   to   = Date.civil(2008,7,31)
  #
  #   Holidays.between(from, to, :ca, :us)
  #   => [{:name => 'Canada Day', :regions => [:ca]...}
  #       {:name => 'Independence Day'', :regions => [:us], ...}]
  def self.between(start_date, end_date, *options)
    # remove the timezone
    start_date = start_date.new_offset(0) + start_date.offset if start_date.respond_to?(:new_offset)
    end_date = end_date.new_offset(0) + end_date.offset if end_date.respond_to?(:new_offset)

    # get simple dates
    if start_date.respond_to?(:to_date)
      start_date = start_date.to_date
    else
      start_date = Date.civil(start_date.year, start_date.mon, start_date.mday)
    end

    if end_date.respond_to?(:to_date)
      end_date = end_date.to_date
    else
      end_date = Date.civil(end_date.year, end_date.mon, end_date.mday)
    end

    regions, observed, informal, hide_date = parse_options(options)
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

          # Skip informal holidays unless they have been requested
          next if h[:type] == :informal and not informal

          if h[:function]
            # Holiday definition requires a calculation
            result = call_proc(h[:function], year)

            # Procs may return either Date or an integer representing mday
            if result.kind_of?(Date)
              month = result.month
              mday = result.mday
            else
              mday = result
            end
          else
            # Calculate the mday
            mday = h[:mday] || Date.calculate_mday(year, month, h[:week], h[:wday])
          end

          # Silently skip bad mdays
          begin
            date = Date.civil(year, month, mday)
          rescue; next; end

          # If the :observed option is set, calculate the date when the holiday
          # is observed.
          if observed and h[:observed]
            date = call_proc(h[:observed], date)
          end

          if date.between?(start_date, end_date)
            holidays << {:date => date, :name => h[:name], :hide_date => h[:hide_date], :regions => h[:regions]}
          end

        end
      end
    end

    holidays.sort{|a, b| a[:date] <=> b[:date] }
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
            # TODO: gross.
            if ex[:name] == holiday_def[:name] and ex[:wday] == holiday_def[:wday] and ex[:mday] == holiday_def[:mday] and ex[:week] == holiday_def[:week] and ex[:function_id] == holiday_def[:function_id] and ex[:type] == holiday_def[:type] and ex[:observed_id] == holiday_def[:observed_id]
              # append regions
              ex[:regions] << holiday_def[:regions]

              # Should do this once we're done
              ex[:regions].flatten!
              ex[:regions].uniq!
              exists = true
            end
          end

          @@holidays_by_month[month] << holiday_def  unless exists
      end
    end
  end

  # Get the date of Easter Sunday in a given year.  From Easter Sunday, it is
  # possible to calculate many traditional holidays in Western countries.
  # Returns a Date object.
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

  # A method to calculate the orthodox easter date, returns date in the Gregorian (western) calendar
  # Safe until appr. 4100 AD, when one leap day will be removed.
  # Returns a Date object.
  def self.orthodox_easter(year)
    y = year
    g = y % 19
    i = (19 * g + 15) % 30
    j = (year + year/4 + i) % 7
    j_month = 3 + (i - j + 40) / 44
    j_day = i - j + 28 - 31 * (j_month / 4)
    j_date = Date.civil(year, j_month, j_day)
    case
      # up until 1582, julian and gregorian easter dates were identical
      when year <= 1582
        offset = 0
      # between the years 1583 and 1699 10 days are added to the julian day count
      when (year >= 1583 and year <= 1699)
        offset = 10
      # after 1700, 1 day is added for each century, except if the century year is exactly divisible by 400 (in which case no days are added).
      # Safe until 4100 AD, when one leap day will be removed.
      when year >= 1700
        offset = (year - 1700).divmod(100)[0] + ((year - year.divmod(100)[1]).divmod(400)[1] == 0 ? 0 : 1) - (year - year.divmod(100)[1] - 1700).divmod(400)[0] + 10
    end
    # add offset to the julian day
    return Date.jd(j_date.jd + offset)
  end

  # A method to calculate the date of the first day of Passover
  def self.passover_start(year)
    passover = HebCal::Passover::WhenIsPesach(year)
    date = Date.civil(passover.to_date.year, passover.to_date.month, passover.to_date.day)
    date -= 1
  end

  # Move date to Monday if it occurs on a Sunday.
  # Used as a callback function.
  def self.to_monday_if_sunday(date)
    date += 1 if date.wday == 0
    date
  end

  # Move date to Monday if it occurs on a Saturday on Sunday.
  # Used as a callback function.
  def self.to_monday_if_weekend(date)
    date += 1 if date.wday == 0
    date += 2 if date.wday == 6
    date
  end

  # Move Boxing Day if it falls on a weekend, leaving room for Christmas.
  # Used as a callback function.
  def self.to_weekday_if_boxing_weekend(date)
    if date.wday == 6 or date.wday == 0
      date += 2
    elsif date.wday == 1
      date += 1
    end
    date
  end

  # Move date to Monday if it occurs on a Sunday or to Friday if it occurs on a
  # Saturday.
  # Used as a callback function.
  def self.to_weekday_if_weekend(date)
    date += 1 if date.wday == 0
    date -= 1 if date.wday == 6
    date
  end

  # Returns an array of symbols all the available holiday definitions.
  #
  # Optional `full_path` param is used internally for loading all the definitions.
  def self.available(full_path = false)
    paths = Dir.glob(DEFINITION_PATH + '/*.rb')
    full_path ? paths : paths.collect { |path| path.match(/([a-z_-]+)\.rb/i)[1].to_sym }
  end

  # Returns an array of symbols of all the available holiday regions.
  def self.regions
    @@regions
  end

  # Load all available holiday definitions
  def self.load_all
    self.available(true).each { |path| require path }
  end

private
  # Returns [(arr)regions, (bool)observed, (bool)informal]
  def self.parse_options(*options) # :nodoc:
    options.flatten!
    observed = options.delete(:observed) ? true : false
    informal = options.delete(:informal) ? true : false
		hide_date = options.delete(:hide_date) ? true: false
    regions = parse_regions(options)
    return regions, observed, informal, hide_date
  end

  # Check regions against list of supported regions and return an array of
  # symbols.
  #
  # If a wildcard region is found (e.g. <tt>:ca_</tt>) it is expanded into all
  # of its available sub regions.
  def self.parse_regions(regions) # :nodoc:
    regions = [regions] unless regions.kind_of?(Array)
    return [:any] if regions.empty?

    regions = regions.collect { |r| r.to_sym }

    # Found sub region wild-card
    regions.delete_if do |reg|
      if reg.to_s =~ /_$/
        prefix = reg.to_s.split('_').first
        unless @@regions.include?(prefix.to_sym)
          begin
            require "holidays/#{prefix}"
          rescue LoadError
            raise UnknownRegionError, "Could not load holidays/#{prefix}"
          end
        end
        regions << @@regions.select { |dr| dr.to_s =~ Regexp.new("^#{reg}") }
        true
      end
    end

    regions.flatten!

    require "holidays/north_america" if regions.include?(:us) # special case for north_america/US cross-linking

    regions.each do |r|
      unless r == :any or @@regions.include?(r)
        begin
          require "holidays/#{r.to_s}"
        rescue LoadError => e
          raise UnknownRegionError, "Could not load holidays/#{r}"
        end
      end
    end
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
# Lookup holidays on North America in January 1.
#   Date.civil(2008,1,1).holidays(:ca, :mx, :us, :informal, :observed)
#   => [{:name => 'New Year\'s Day'...}]
class Date
  include Holidays

  # Get holidays on the current date.
  #
  # Returns an array of hashes or nil. See Holidays#between for options
  # and the output format.
  #
  #   Date.civil('2008-01-01').holidays(:ca_)
  #   => [{:name => 'New Year\'s Day',...}]
  #
  # Also available via Holidays#on.
  def holidays(*options)
    Holidays.on(self, options)
  end

  # Check if the current date is a holiday.
  #
  # Returns true or false.
  #
  #   Date.civil('2008-01-01').holiday?(:ca)
  #   => true
  def holiday?(*options)
    holidays = self.holidays(options)
    holidays && !holidays.empty?
  end

  # Calculate day of the month based on the week number and the day of the
  # week.
  #
  # ==== Parameters
  # [<tt>year</tt>]  Integer.
  # [<tt>month</tt>] Integer from 1-12.
  # [<tt>week</tt>]  One of <tt>:first</tt>, <tt>:second</tt>, <tt>:third</tt>,
  #                  <tt>:fourth</tt>, <tt>:fifth</tt> or <tt>:last</tt>.
  # [<tt>wday</tt>]  Day of the week as an integer from 0 (Sunday) to 6
  #                  (Saturday) or as a symbol (e.g. <tt>:monday</tt>).
  #
  # Returns an integer.
  #
  # ===== Examples
  # First Monday of January, 2008:
  #   Date.calculate_mday(2008, 1, :first, :monday)
  #   => 7
  #
  # Third Thursday of December, 2008:
  #   Date.calculate_mday(2008, 12, :third, :thursday)
  #   => 18
  #
  # Last Monday of January, 2008:
  #   Date.calculate_mday(2008, 1, :last, 1)
  #   => 28
  #--
  # see http://www.irt.org/articles/js050/index.htm
  def self.calculate_mday(year, month, week, wday)
    raise ArgumentError, "Week parameter must be one of Holidays::WEEKS (provided #{week})." unless WEEKS.include?(week) or WEEKS.has_value?(week)

    unless wday.kind_of?(Numeric) and wday.between?(0,6) or DAY_SYMBOLS.index(wday)
      raise ArgumentError, "Wday parameter must be an integer between 0 and 6 or one of Date::DAY_SYMBOLS."
    end

    week = WEEKS[week] if week.kind_of?(Symbol)
    wday = DAY_SYMBOLS.index(wday) if wday.kind_of?(Symbol)

    # :first, :second, :third, :fourth or :fifth
    if week > 0
      return ((week - 1) * 7) + 1 + ((wday - Date.civil(year, month,(week-1)*7 + 1).wday) % 7)
    end

    days = MONTH_LENGTHS[month-1]

    days = 29 if month == 2 and Date.leap?(year)

    return days - ((Date.civil(year, month, days).wday - wday + 7) % 7) - (7 * (week.abs - 1))
  end
end
