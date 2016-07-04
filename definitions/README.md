# Holiday Gem Definition Syntax

All holidays are defined in YAML files in the `definitions/` directory. These definition files have three main top-level properties:

* `months` - this is the meat! All definitions for months 1-12 are defined here
* `methods` - this contains any custom logic that your definitions require
* `tests` - this contains the tests for your definitions

The `months` property is required. The two other properties are not strictly required but are almost always used.

In fact, if you leave out `tests` your PR will probably not be accepted unless there is a very, very good reason for leaving it out.

## Key Words

There are some terms that you should be familiar with before we dive into each section:

#### `region`

A region is a symbol that denotes the geographic or cultural region for that holiday. In general these symbols will be the [ISO 3166](https://en.wikipedia.org/wiki/ISO_3166) code for a country or region.

Please note that before version v1.1.0 the compliance with ISO 3166 was not as strict. There might be cases where an existing region symbol does not match the standard.

In addition, some sub-regions do not have a matching ISO 3116 entry. In those cases we attempt to choose symbols that are reasonably clear.

Examples: `:us` for USA, `:fr` for France, `:us_dc` for Washington, D.C in USA

#### `formal`/`informal`

We consider `formal` dates as government-defined holidays. These could be the kinds of holidays where everyone stays home from work or perhaps are bank holidays but it is *not required* for a holiday to have these features to be considered formal.

`Informal` holidays are holidays that everyone knows about but aren't enshrined in law. For example, Valentine's Day in the US is considered an informal holiday.

We recognize that these definitions can be highly subjective. If you disagree with the current status of a holiday please open an issue so we can discuss it.

#### `observed`

There are certain holidays that can be legally observed on different days than they occur. For example, if a holiday falls on a Saturday but it is legally observed on the following Monday then you can define it as `observed` on the Monday. Please see the section below for more details and examples.

## Months

Holidays are grouped by month from 1 through 12.  Each entry within a month can have several properties depending on the behavior of the holiday. Each section below lays out the various different ways you can define your holiday.

The two required properties are:

* `name` - The name of the holiday
* `regions` - One or more region codes (targeted to match [ISO 3166](https://en.wikipedia.org/wiki/ISO_3166))

### Dates defined by a fixed date (e.g. January 1st)

* `mday` - A non-negative integer representing day of the month (1 through 31).

For example, the following holiday is on the first of January and available in the `:ca`, `:us` and `:au` regions:

```yaml
1:
- name: New Year's Day
  regions: [ca, us, au]
  mday: 1
```

### Dates defined by a week number (e.g. first Monday of a month)

* `wday` - A non-negative integer representing day of the week (0 = Sunday through 6 = Saturday).
* `week` - A non-negative integer representing week number (1 = first week, 3 = third week, -1 = last week),

For example, the following holiday is on the first Monday of September and available in the `:ca` region:

```yaml
9:
- name: Labour Day
  regions: [ca]
  week: 1
  wday: 1
```

### 'Formal' vs 'Informal' types

As mentioned above you can specify two different types. By default a holiday is considered 'formal'. By adding a `type: informal` to a definition you will mark it as 'informal' and it will only show up if the user specifically asks for it.

Example:

```yaml
9:
- name: Some Holiday
  regions: [fr]
  mday: 1
  type: informal
```

If a user submits:

```ruby
Holidays.on(Date.civil(2016, 9, 1), :fr)
```

then they will not see the holiday. However, if they submit:

```ruby
Holidays.on(Date.civil(2016, 9, 1), :fr, :informal)
```

Then the holiday will be returned. This is especially useful for holidays like "Valentine's Day" in the USA, where it is commonly recognized as a holiday in society but not as a day that is celebrated by taking the day off.

### Year ranges

Certain holidays in various countries are only in effect during specific year ranges. For example, a new holiday might come into effect that is only valid after a specific year (say, 2017).

To address this we have the ability to specify these 'year ranges' in the definition. The gem will then only return a match on a date that adheres to these rules.

There are a total of four selectors that can be specified. All must be specified in terms of 'years'.

#### `before`

The 'before' selector will only find a match if the supplied date takes place
before or equal to the holiday.

Example:

```yaml
7:
  name: 振替休日
  regions: [jp]
  mday: 1
  year_ranges:
    - before: 2002
```

This will return successfully:

```ruby
Holidays.on(Date.civil(2000, 7, 1), :jp)
```

This will not:

```ruby
Holidays.on(Date.civil(2016, 7, 1), :jp)
```

#### `after`

The 'after' selector will only find a match if the supplied date takes place
after or equal to the holiday.

Example:

```yaml
7:
  name: 振替休日
  regions: [jp]
  mday: 1
  year_ranges:
    - after: 2002
```

This will return successfully:

```ruby
Holidays.on(Date.civil(2016, 7, 1), :jp)
```

This will not:

```ruby
Holidays.on(Date.civil(2000, 7, 1), :jp)
```

#### `limited`

The 'limited' selector will only find a match if the supplied date takes place during
one of the specified years. Multiple years can be specified.

An array of years *must* be supplied. Individual integers will result in an error.

Example:

```yaml
7:
  name: 振替休日
  regions: [jp]
  mday: 1
  year_ranges:
    - limited: [2002]
```

This will return successfully:

```ruby
Holidays.on(Date.civil(2002, 7, 1), :jp)
```

This will not:

```ruby
Holidays.on(Date.civil(2000, 7, 1), :jp)
```

#### `between`

The 'between' selector will only find a match if the supplied date takes place during the specified range of years. Only a single range is allowed at this time.

Example:

```yaml
7:
  name: 振替休日
  regions: [jp]
  mday: 1
  year_ranges:
    - between: 1996..2002
```

This will return successfully:

```ruby
Holidays.on(Date.civil(2000, 7, 1), :jp)
```

This will not:

```ruby
Holidays.on(Date.civil(2003, 7, 1), :jp)
Holidays.on(Date.civil(1995, 7, 1), :jp)
```

## Methods

In addition to defining holidays by day or week, you can create custom methods to calculate a date. These should be placed under the `methods` property. Methods named in this way can then be referenced by entries in the `months` property.

For example, Canada celebrates Victoria Day, which falls on the Monday on or before May 24.  So, under the `methods` property we create a custom method that returns a Date object.

```
methods:
  ca_victoria_day:
    arguments: year
    source: |
      date = Date.civil(year, 5, 24)
      if date.wday > 1
        date -= (date.wday - 1)
      elsif date.wday == 0
        date -= 6
      end

      date
```

This would be represented in `months` entry as:

```
5:
- name: Victoria Day
  regions: [ca]
  function: ca_victoria_day(year)
```

If a holiday can occur in different months (e.g. Easter) it can go in the '0' month.

```
0:
- name: Easter Monday
  regions: [ca]
  function: easter(year)
```

There are pre-existing methods for highly-used calculations. They are:

* `easter(year)` - calculates Easter via Gregorian calendar for a given year
* `orthodox_easter(year)` - calculates Easter via Julian calendar for a given year
* `to_monday_if_sunday(date)` - returns date of the following Monday if the 'date' argument falls on a Sunday
* `to_monday_if_weekend(date)` - returns date of the following Monday if the 'date' argument falls on a weekend (Saturday or Sunday)
* `to_weekday_if_boxing_weekend(date)` - returns nearest following weekday if the 'date' argument falls on Boxing Day
* `to_weekday_if_boxing_weekend_from_year(year)` - calculates nearest weekday following Boxing weekend for given year
* `to_weekday_if_weekend(date)` - returns nearest weekday (Monday or Friday) if 'date' argument falls on a weekend (Saturday or Sunday)

*Protip*: you can use the `easter` methods to calculate all of the dates that are based around Easter. It's especially useful to use since the Easter calculation is complex. For example, 'Good Friday' in the US is 2 days before Easter. Therefore you could do the following:

```
0:
- name: Good Friday
  regions: [us]
  function: easter(year)
  function_modifier: -2
  type: informal
```

Use the `function_modifier` property, which can be positive or negative, to modify the result of the function.

In addition, you may only specify the following values for arguments into a custom method: `date`, `year`, `month`, `day`.

If attempt to specify anything else then you will receive an error on definition generation. This is because these are the only values that are available to
call into the custom methods will calculating the result of a function.

Correct example:

```
1:
- name: Custom Method
  regions: [us]
  function: custom_method(year, month, day)
```

If you do the following:

```
1:
- name: Custom Method
  regions: [us]
  function: custom_method(week)
```

This will result in an error since `week` is not a recognized method argument.

### Calculating observed dates

Users can specify that this gem only return holidays on their 'observed' day. This can be especially useful if they are using this gem for business-related logic. If you wish for your definitions to allow for this then you can add the `observed` property to your entry. This requires a method to help calculate the observed day.

Several built-in methods are available for holidays that are observed on varying dates.  For example, for a holiday that is observed on Monday if it falls on a weekend you could write:

```
7:
- name: Canada Day
  regions: [ca]
  mday: 1
  observed: to_monday_if_weekend(date)
```

If a user does not specify `observed` when calling the gem then 1/1 will be the date found for 'Canada Day', regardless of whether it falls on a Saturday or Sunday. If a user specifies 'observed' then it will show as the following Monday if the date falls on a Saturday or Sunday.

## Tests

All definition files should have tests included.  In the YAML file, tests are just a block of Ruby code:

```
tests: |
  {Date.civil(2008,1,1) => 'New Year\'s Day',
   Date.civil(2008,3,21) => 'Good Friday',
   Date.civil(2008,3,24) => 'Easter Monday',
   Date.civil(2008,9,1) => 'Labour Day',
   Date.civil(2008,12,25) => 'Christmas Day',
   Date.civil(2008,12,26) => 'Boxing Day'}.each do |date, name|
    assert_equal name, (Holidays.on(date, :ca, :informal)[0] || {})[:name]
  end

  # Victoria Day
  [Date.civil(2004,5,24), Date.civil(2005,5,23), Date.civil(2006,5,22),
   Date.civil(2007,5,21), Date.civil(2008,5,19)].each do |date|
    assert_equal 'Victoria Day', Holidays.on(date, :ca)[0][:name]
  end
```

These tests will be picked up by the `generate` process and written into actual Test::Unit tests that are run when a user executes the test suite.

Please please please include tests. Your PR won't be accepted if tests are not included with your changes.
