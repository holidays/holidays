## encoding: utf-8
$:.unshift File.dirname(__FILE__)

require 'date'
require 'digest/md5'
require 'holidays/factory/definition'
require 'holidays/factory/date_calculator'
require 'holidays/factory/finder'
require 'holidays/errors'
require 'holidays/load_all_definitions'

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
  WEEKS = {:first => 1, :second => 2, :third => 3, :fourth => 4, :fifth => 5, :last => -1, :second_last => -2, :third_last => -3}
  MONTH_LENGTHS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  DAY_SYMBOLS = Date::DAYNAMES.collect { |n| n.downcase.intern }

  DEFINITIONS_PATH = 'generated_definitions'
  FULL_DEFINITIONS_PATH = File.expand_path(File.dirname(__FILE__) + "/#{DEFINITIONS_PATH}")

  class << self
    # Does the given work-week have any holidays?
    #
    # [<tt>date</tt>]   A Date object.
    # [<tt>:options</tt>] One or more region symbols, and/or <tt>:informal</tt>. Automatically includes <tt>:observed</tt>. If you don't want this, pass <tt>:no_observed</tt>
    #
    # The given Date can be any day of the week.
    # Returns true if any holidays fall on Monday - Friday of the given week.
    def any_holidays_during_work_week?(date, *options)
      days_to_monday = date.wday - 1
      days_to_friday = 5 - date.wday
      start_date = date - days_to_monday
      end_date = date + days_to_friday
      options += [:observed] unless options.include?(:no_observed)
      options.delete(:no_observed)
      between(start_date, end_date, options).empty?
    end

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
      raise ArgumentError unless start_date && end_date

      # remove the timezone
      start_date = start_date.new_offset(0) + start_date.offset if start_date.respond_to?(:new_offset)
      end_date = end_date.new_offset(0) + end_date.offset if end_date.respond_to?(:new_offset)

      start_date, end_date = get_date(start_date), get_date(end_date)

      if cached_holidays = Factory::Definition.cache_repository.find(start_date, end_date, options)
        return cached_holidays
      end

      Factory::Finder.between.call(start_date, end_date, options)
    end

    # Get next holidays occuring from date, inclusively.
    #
    # Returns an array of hashes or nil.
    #
    # Incoming arguments are below:
    # [<tt>holidays_count</tt>]  Ruby Numeric object. This is the number of holidays to return
    # [<tt>options</tt>]     One or more region symbols, <tt>:informal</tt> and/or <tt>:observed</tt>.
    # [<tt>from_date</tt>]    Ruby Date object. This is an optional param, defaulted today.
    #
    # ==== Example
    #   Date.today
    #   => Tue, 23 Feb 2016
    #
    #   regions = [:us, :informal]
    #
    #   Holidays.next_holidays(3, regions)
    #   => [{:name => "St. Patrick's Day",...},
    #       {:name => "Good Friday",...},
    #       {:name => "Easter Sunday",...}]
    def next_holidays(holidays_count, options, from_date = Date.today)
      raise ArgumentError unless holidays_count
      raise ArgumentError if options.empty?
      raise ArgumentError unless options.is_a?(Array)

      # remove the timezone
      from_date = from_date.new_offset(0) + from_date.offset if from_date.respond_to?(:new_offset)

      from_date = get_date(from_date)

      Factory::Finder.next_holiday.call(holidays_count, from_date, options)
    end

    # Get all holidays occuring from date to end of year, inclusively.
    #
    # Returns an array of hashes or nil.
    #
    # Incoming arguments are below:
    # [<tt>options</tt>]  One or more region symbols, <tt>:informal</tt> and/or <tt>:observed</tt>.
    # [<tt>from_date</tt>]    Ruby Date object. This is an optional param, defaulted today.
    #
    # ==== Example
    #   Date.today
    #   => Tue, 23 Feb 2016
    #
    #   regions = [:ca_on]
    #
    #   Holidays.year_holidays(regions)
    #   => [{:name=>"Good Friday",...},
    #       {name=>"Easter Sunday",...},
    #       {:name=>"Victoria Day",...},
    #       {:name=>"Canada Day",...},
    #       {:name=>"Civic Holiday",...},
    #       {:name=>"Labour Day",...},
    #       {:name=>"Thanksgiving",...},
    #       {:name=>"Remembrance Day",...},
    #       {:name=>"Christmas Day",...},
    #       {:name=>"Boxing Day",...}]
    def year_holidays(options, from_date = Date.today)
      raise ArgumentError if options.empty?
      raise ArgumentError unless options.is_a?(Array)

      # remove the timezone
      from_date = from_date.new_offset(0) + from_date.offset if from_date.respond_to?(:new_offset)
      from_date = get_date(from_date)

      Factory::Finder.year_holiday.call(from_date, options)
    end

    # Allows a developer to explicitly calculate and cache holidays within a given period
    def cache_between(start_date, end_date, *options)
      start_date, end_date = get_date(start_date), get_date(end_date)
      cache_data = between(start_date, end_date, *options)

      Factory::Definition.cache_repository.cache_between(start_date, end_date, cache_data, options)
    end

    # Returns an array of symbols of all the available holiday regions.
    def available_regions
      Holidays::REGIONS
    end

    # Parses provided holiday definition file(s) and loads them so that they are immediately available.
    def load_custom(*files)
      regions, rules_by_month, custom_methods, tests = Factory::Definition.file_parser.parse_definition_files(files)

      custom_methods.each do |method_key, method_entity|
        custom_methods[method_key] = Factory::Definition.custom_method_proc_decorator.call(method_entity)
      end

      Factory::Definition.merger.call(regions, rules_by_month, custom_methods)

      rules_by_month
    end

    private

    def get_date(date)
      if date.respond_to?(:to_date)
        date.to_date
      else
        Date.civil(date.year, date.mon, date.mday)
      end
    end
  end
end

Holidays::LoadAllDefinitions.call
