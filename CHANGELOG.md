# Ruby Holidays Gem CHANGELOG

## 1.0.7.pre

* Added European Central Bank TARGET definitions (Toby Bryans, NASDAQ OMX NLX)
* FR: Make Pâques and Pentecôte informal holidays (https://github.com/wizcover)
* NL: Update for the new King (https://github.com/johankok)
* Added Slovenian definitions (https://github.com/bbalon)

## 1.0.6

* Added `Holidays.regions` method (https://github.com/sonnym)
* Added Slovakian definitions (https://github.com/mirelon)
* Added Venezuelan definitions (https://github.com/Chelo)
* Updated Canadian definitions (https://github.com/sdavies)
* Updated Argentinian definitions (https://github.com/popox)
* Updated Australian definitions (https://github.com/ghiculescu)
* Updated Portuguese definitions (https://github.com/MiPereira)
* Added Swiss definitions (https://github.com/samzurcher, https://github.com/jg)
* Added Romanian definitions (https://github.com/mtarnovan)
* Added Belgian definitions (https://github.com/jak78)
* Added Moroccan definitions (https://github.com/jak78)
* Fixes for New Year's and Boxing Day (https://github.com/iterion, https://github.com/andyw8)
* Fixes for Father's Day, Mother's Day and Armed Forces Day (https://github.com/eheikes)
* Typos (https://github.com/gregoriokusowski, https://github.com/popox)
* Added Croatian definitions (https://github.com/lecterror)
* Added US Federal Reserve holidays (https://github.com/willbarrett)
* Added NERC holidays (https://github.com/adamstrickland)
* Updated Irish holidays (https://github.com/xlcrs)

## 1.0.5

* Added `full_week?` method (https://github.com/dceddia)
* Added Portuguese definitions (https://github.com/pmor)
* Added Hungarian definitions (https://github.com/spap)
* Typos (https://github.com/DenisKnauf)

## 1.0.4

* Add Liechtenstein holiday defs (mercy vielmal Bernhard Furtmueller)

## 1.0.3

* Add Austrian holiday definitions (thanks to Vogel Siegfried)

## 1.0.2

* Add `orthodox_easter` method and Greek holiday definitions (thanks https://github.com/ddimitriadis)

## 1.0.0

* Support calculating mday from negative weeks other than -1 (thanks https://github.com/bjeanes)
* Use class method to check leap years and fixed bug in Date.calculate_mday (thanks https://github.com/dgrambow)
* Added Czech (thanks https://github.com/boblin), Brazilian (https://github.com/fabiokr), Norwegian (thanks to Peter Skeide) and Australia/Brisbane (https://github.com/bjeanes) definitions
* Cleaned up rake and gemspec

## 0.9.3

* Added New York Stock Exchange holidays (thank you Alan Larkin).
* Added UPS holidays (thank you Tim Anglade).
* Fixed rakefile to force lower case definition file names.

## 0.9.2

* Included rakefile in Gem (thank you James Herdman).

## 0.9.1

* au.yaml was being included incorrectly in US holiday definitions. Thanks to [Glenn Vanderburg](http://vanderburg.org/) for the fix.

## 0.9.0

* Initial release.
