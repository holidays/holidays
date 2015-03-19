# Ruby Holidays Gem [![Build Status](https://travis-ci.org/alexdunae/holidays.svg?branch=master)](https://travis-ci.org/alexdunae/holidays)

A set of functions to deal with holidays in Ruby.

Extends Ruby's built-in Date class and supports custom holiday definition lists.

Full documentation can be found [here](http://www.rubydoc.info/github/alexdunae/holidays/master/frames).

## Installation

To install the gem from RubyGems:

    gem install holidays

The Holidays gem is tested on Ruby 1.8.7, 1.9.2, 1.9.3, 2.0.0, 2.1.0, REE and JRuby.

## Time zones

Time zones are ignored.  This library assumes that all dates are within the same time zone.

## Examples

For more information, see the notes at the top of the Holidays module.

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

### Loading Custom Definitions on the fly

Load custom definitions file on the fly and use them immediately.

Load custom 'Company Founding' holiday on June 1st:

    Holidays.load_custom('/home/user/holiday_definitions/custom_holidays.yaml')

    date = Date.civil(2013,6,1)

    Holidays.on(date, :my_custom_region)
      => [{:name => 'Company Founding',...}]

Custom definition files must match the format of the existing definition YAML files location in the 'data' directory.

Multiple files can also be passed:

    Holidays.load_custom('/home/user/holidays/custom_holidays1.yaml', '/home/user/holidays/custom_holidays2.yaml')

### Extending Ruby's Date class

Check which holidays occur in Iceland on January 1, 2008.

    d = Date.civil(2008,7,1)

    d.holidays(:is)
    => [{:name => 'Nýársdagur'}...]

Lookup Canada Day in different regions.

    d = Date.civil(2008,7,1)

    d.holiday?(:ca) # Canada
    => true

    d.holiday?(:ca_bc) # British Columbia, Canada
    => true

    d.holiday?(:fr) # France
    => false

### Caching Holiday Lookups

If you are checking holidays regularly you can cache your results for improved performance. Run this before looking up a holiday (eg. in an initializer):

    Holidays.cache_between(Time.now, 2.years.from_now, :ca, :us, :observed)

Holidays for the regions specified within the dates specified will be pre-calculated.

### How to contribute

To make changes to any of the definitions, edit the YAML files only.

Tests are also added at the end of the YAML files. Please add tests, it makes the pull requests go around.

After you're satisfied with the YAML file, edit the index.yaml file, run `rake generate`, which will generate the Ruby files that make up the actual code as well as the tests.  Then run `rake test`.

It is also very appreciated if documentation is attached to the pull request.  A simple Wikipedia or government link referencing the change would be perfect.

### Credits and code

* Started by [Alex Dunae](http://dunae.ca) (e-mail 'code' at the same domain), 2007-12
* Maintained by [Hana Wang](https://github.com/hahahana), 2013
* Maintained by [Phil Trimble](https://github.com/ptrimble), 2014-present

Plus all of these [wonderful contributors!](https://github.com/alexdunae/holidays/contributors)
