= Ruby Holidays Gem
  
A set of functions to deal with holidays in Ruby.

Extends Ruby's built-in Date class and supports custom holiday definition lists.

=== Installation

To install the gem from RubyForge:

  gem install holidays

Or, download the source <tt>.tgz</tt> file from http://rubyforge.org/holidays and 
extract it somewhere in your include path.

=== Examples

For more information, see the notes at the top of the Holidays module.

==== Using the Holidays class
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
  to   = Date.civil(2008,7,31)

  Holidays.between(from, to, :ca, :us)
  => [{:name => 'Canada Day',...}
      {:name => 'Independence Day',...}]

Get informal holidays in February.
  from = Date.civil(2008,2,1)
  to   = Date.civil(2008,2,15)

  Holidays.between(from, to)
  => [{:name => 'Valentine\'s Day',...}]


==== Extending Ruby's Date class
Check which holidays occur in Iceland on January 1, 2008.
  d = Date.civil(2008,7,1)

  d.holidays(:is)
  => [{:name => 'Nýársdagur'}...]

Lookup Canada Day in different regions.
  d = Date.civil(2008,7,1)

  d.holiday?(:ca)     # Canada
  => true

  d.holiday?(:ca_bc)  # British Columbia, Canada
  => true

  d.holiday?(:fr)     # France
  => false

=== Credits and code

* Project page: http://code.dunae.ca/holidays
* Source: http://code.dunae.ca/svn/holidays
* Docs: http://code.dunae.ca/holidays/doc

By Alex Dunae (dunae.ca, e-mail 'code' at the same domain), 2007-08.

Made on Vancouver Island.