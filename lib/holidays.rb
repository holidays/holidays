# encoding: utf-8
$:.unshift File.dirname(__FILE__)

require 'date'
require 'holidays/definition_factory'
require 'holidays/date_calculator_factory'
require 'holidays/option_factory'

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

  WEEKS = {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :last => -1, :second_last => -2, :third_last => -3}
  MONTH_LENGTHS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  DAY_SYMBOLS = Date::DAYNAMES.collect { |n| n.downcase.intern }

  DEFINITIONS_PATH = 'generated_definitions'
  FULL_DEFINITIONS_PATH = File.expand_path(File.dirname(__FILE__) + "/#{DEFINITIONS_PATH}")

  class << self
    # Get all holidays on a given date.
    #
    # [<tt>date</tt>]     A Date object.
    # [<tt>:options</tt>] One or more region symbols, <tt>:informal</tt> and/or <tt>:observed</tt>.
    #
    # Returns an array of hashes or nil. See Holidays#between for the output
    # format.
    #
    # Also available via Date#holidays.
    def on(date, *options)
      between(date, date, options)
    end

    # Does the given work-week have any holidays?
    #
    # [<tt>date</tt>]   A Date object.
    # [<tt>:options</tt>] One or more region symbols, and/or <tt>:informal</tt>. Automatically includes <tt>:observed</tt>. If you don't want this, pass <tt>:no_observed</tt>
    #
    # The given Date can be any day of the week.
    # Returns true if any holidays fall on Monday - Friday of the given week.
    def full_week?(date, *options)
      days_to_monday = date.wday - 1
      days_to_friday = 5 - date.wday
      start_date = date - days_to_monday
      end_date = date + days_to_friday
      options += [:observed] unless options.include?(:no_observed)
      options.delete(:no_observed)
      between(start_date, end_date, options).empty?
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
    def between(start_date, end_date, *options)
      # remove the timezone
      start_date = start_date.new_offset(0) + start_date.offset if start_date.respond_to?(:new_offset)
      end_date = end_date.new_offset(0) + end_date.offset if end_date.respond_to?(:new_offset)

      # get simple dates
      start_date, end_date = get_date(start_date), get_date(end_date)

      if cached_holidays = DefinitionFactory.cache_repository.find(start_date, end_date, options)
        return cached_holidays
      end

      regions, observed, informal = OptionFactory.parse_options.call(options)
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
          next unless hbm = DefinitionFactory.holidays_by_month_repository.find_by_month(month)

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
              mday = h[:mday] || DateCalculatorFactory.day_of_month_calculator.call(year, month, h[:week], h[:wday])
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
              holidays << {:date => date, :name => h[:name], :regions => h[:regions]}
            end

          end
        end
      end

      holidays.sort{|a, b| a[:date] <=> b[:date] }
    end

    # Allows a developer to explicitly calculate and cache holidays within a given period
    def cache_between(start_date, end_date, *options)
      start_date, end_date = get_date(start_date), get_date(end_date)
      cache_data = between(start_date, end_date, *options)

      DefinitionFactory.cache_repository.cache_between(start_date, end_date, cache_data, options)
    end

    #TODO This should not be publicly available. I need to restructure the public
    #     API for this class to something more sensible.
    def merge_defs(regions, holidays) # :nodoc:
      DefinitionFactory.merger.call(regions, holidays)
    end

    def easter(year)
      DateCalculatorFactory.easter_calculator.calculate_easter_for(year)
    end

    def orthodox_easter(year)
      DateCalculatorFactory.easter_calculator.calculate_orthodox_easter_for(year)
    end

    def to_monday_if_sunday(date)
      DateCalculatorFactory.weekend_modifier.to_monday_if_sunday(date)
    end

    def to_monday_if_weekend(date)
      DateCalculatorFactory.weekend_modifier.to_monday_if_weekend(date)
    end

    # Move Boxing Day if it falls on a weekend, leaving room for Christmas.
    # Used as an observed function.
    def to_weekday_if_boxing_weekend(date)
      DateCalculatorFactory.weekend_modifier.to_weekday_if_boxing_weekend(date)
    end

    # Call to_weekday_if_boxing_weekend but first get date based on year
    # Used as a callback function.
    def to_weekday_if_boxing_weekend_from_year(year)
      to_weekday_if_boxing_weekend(Date.civil(year, 12, 26))
    end

    # Move date to Monday if it occurs on a Sunday or to Friday if it occurs on a
    # Saturday.
    # Used as a callback function.
    def to_weekday_if_weekend(date)
      DateCalculatorFactory.weekend_modifier.to_weekday_if_weekend(date)
    end

    def calculate_day_of_month(year, month, day, wday)
      DateCalculatorFactory.day_of_month_calculator.call(year, month, day, wday)
    end

    # Returns an array of symbols all the available holiday definitions.
    #
    # Optional `full_path` param is used internally for loading all the definitions.
    def available(full_path = false)
      paths = Dir.glob(FULL_DEFINITIONS_PATH + '/*.rb')
      full_path ? paths : paths.collect { |path| path.match(/([a-z_-]+)\.rb/i)[1].to_sym }
    end

    # Returns an array of symbols of all the available holiday regions.
    def regions
      DefinitionFactory.regions_repository.all
    end

    # Load all available holiday definitions
    def load_all
      available(true).each { |path| require path }
    end

    # Parses provided holiday definition file(s) and loads them so that they are immediately available.
    def load_custom(*files)
      regions, rules_by_month, custom_methods, tests = DefinitionFactory.file_parser.parse_definition_files(files)
      merge_defs(regions, rules_by_month)
    end

    # Parses provided holiday definition file(s) and returns strings containing the generated module and test source
    def parse_definition_files_and_return_source(module_name, *files)
      regions, rules_by_month, custom_methods, tests = DefinitionFactory.file_parser.parse_definition_files(files)
      module_src, test_src = DefinitionFactory.source_generator.generate_definition_source(module_name, files, regions, rules_by_month, custom_methods, tests)

      return module_src, test_src
    end

    private

    def get_date(date)
      if date.respond_to?(:to_date)
        date.to_date
      else
        Date.civil(date.year, date.mon, date.mday)
      end
    end

    # Check sub regions.
    #
    # When request :any, all holidays should be returned.
    # When requesting :ca_bc, holidays in :ca or :ca_bc should be returned.
    # When requesting :ca, holidays in :ca but not its subregions should be returned.
    def in_region?(requested, available) # :nodoc:
      return true if requested.include?(:any)

      # When an underscore is encountered, derive the parent regions
      # symbol and include both in the requested array.
      requested = requested.collect do |r|
        r.to_s =~ /_/ ? [r, r.to_s.gsub(/_[\w]*$/, '').to_sym] : r
      end

      requested = requested.flatten.uniq

      available.any? { |avail| requested.include?(avail) }
    end

    def call_proc(function, year) # :nodoc:
      DefinitionFactory.proc_cache_repository.lookup(function, year)
    end
  end
end
