# Ruby Holidays Gem [![Build Status](https://travis-ci.org/holidays/holidays.svg?branch=master)](https://travis-ci.org/holidays/holidays) [![Coverage Status](https://coveralls.io/repos/holidays/holidays/badge.svg)](https://coveralls.io/r/holidays/holidays)

A set of functions to deal with holidays in Ruby.

Extends Ruby's built-in Date class and supports custom holiday definition lists.

Full documentation can be found [here](http://www.rubydoc.info/github/alexdunae/holidays/master/frames).

## Installation

To install the gem from RubyGems:

    gem install holidays

The Holidays gem is tested on Ruby 2.0.0, 2.1.0, 2.2.0, 2.3.0 and JRuby.

This gem follows [semantic versioning](http://semver.org/). The only methods covered by this guarantee are under the
`Holidays` namespace specifically. Anything that is not a method off of `Holidays` or the core extension is not covered by
semver. Please take this into account when relying on this gem as a dependency.

## Time zones

Time zones are ignored.  This library assumes that all dates are within the same time zone.

### Using the Holidays class

Get all holidays on April 25, 2008 in Australia.

    date = Date.civil(2008,4,25)

    Holidays.on(date, :au)
    => [{:name => 'ANZAC Day',...}]

Get holidays that are observed on July 2, 2007 in British Columbia, Canada.

    date = Date.civil(2007,7,2)

    Holidays.on(date, :ca_bc, :observed)
    => [{:name => 'Canada Day',...}]

Get all holidays in July, 2008 in Canada and the US.

    from = Date.civil(2008,7,1)
    to = Date.civil(2008,7,31)

    Holidays.between(from, to, :ca, :us)
    => [{:name => 'Canada Day',...}
        {:name => 'Independence Day',...}]

Get informal holidays in February.

    from = Date.civil(2008,2,1)
    to = Date.civil(2008,2,15)

    Holidays.between(from, to, :informal)
    => [{:name => 'Valentine\'s Day',...}]

Return all available regions:

    Holidays.available_regions
    => [:ar, :at, ..., :sg] # this will be a big array

To check if there are any holidays taking place during a specified work week:

    Holidays.any_holidays_during_work_week?(Date.civil(2016, 1, 1))
    => true

### Loading Custom Definitions on the fly

Load custom definitions file on the fly and use them immediately.

Load custom 'Company Founding' holiday on June 1st:

    Holidays.load_custom('/home/user/holiday_definitions/custom_holidays.yaml')

    date = Date.civil(2013,6,1)

    Holidays.on(date, :my_custom_region)
      => [{:name => 'Company Founding',...}]

Custom definition files must match the format of the existing definition YAML files location in the 'definitions' directory.

Multiple files can also be passed:

    Holidays.load_custom('/home/user/holidays/custom_holidays1.yaml', '/home/user/holidays/custom_holidays2.yaml')

### Extending Ruby's Date class

To extend the 'Date' class:

    require 'holidays/core_extensions/date'
    class Date
      include Holidays::CoreExtensions::Date
    end

Now you can check which holidays occur in Iceland on January 1, 2008:

    d = Date.civil(2008,7,1)

    d.holidays(:is)
    => [{:name => 'Nýársdagur'}...]

Or lookup Canada Day in different regions:

    d = Date.civil(2008,7,1)

    d.holiday?(:ca) # Canada
    => true

    d.holiday?(:ca_bc) # British Columbia, Canada
    => true

    d.holiday?(:fr) # France
    => false

Or you can calculate the day of the month:

    Date.calculate_mday(2015, 4, :first, 2)
    => 7

### Caching Holiday Lookups

If you are checking holidays regularly you can cache your results for improved performance. Run this before looking up a holiday (eg. in an initializer):

    Holidays.cache_between(Time.now, 2.years.from_now, :ca, :us, :observed)

Holidays for the regions specified within the dates specified will be pre-calculated and stored in-memory. Future lookups will be much faster.

### How to contribute

See our [contribution guidelines](CONTRIBUTING.md) for information on how to help out!

### Credits and code

* Started by [Alex Dunae](http://dunae.ca) (e-mail 'code' at the same domain), 2007-12
* Maintained by [Hana Wang](https://github.com/hahahana), 2013
* Maintained by [Phil Trimble](https://github.com/ptrimble), 2014-present

Plus all of these [wonderful contributors!](https://github.com/holidays/holidays/contributors)
