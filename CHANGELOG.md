# Ruby Holidays Gem CHANGELOG

## 3.3.0

This is the final minor point release in v3.X.X. I am releasing it so that all of the latest definitions can be
used by anyone that is not ready to jump to version 4.0.0. I am not planning on supporting this version unless a major
issue is found that needs to be immediately addressed.

* Update public holidays for Argentina (https://github.com/schmierkov)
* Remove redundant `require` from weekend modifier (https://github.com/Eric-Guo)
* FIX: Easter Saturday not a holiday in NZ (https://github.com/ghiculescu)
* FIX: Japan 'Marine Day' for 1996-2002 year ranges (https://github.com/shuhei)
* FIX: Australia calculations for Christmas and Boxing (https://github.com/ghiculescu)
* Add dutch language version of definitions for Belgium (michael.cox@novalex.be)
* Make 'Goede Vrijdag' informal for NL definitions (https://github.com/MathijsK93)
* Add 'Great Friday' to Czech holidays (juris@uol.cz)
* Add new informal holidays for Germany (https://github.com/knut2)
* FIX: correctly check for new `year_range` attribute in holidays by month repository (https://github.com/knut2)
* Add DE-Reformationstag for 2017 (https://github.com/knut2)
* Update Australia QLD definition Queens Bday and Labour Day (https://github.com/ghiculescu)

## 3.2.0

* add 'valid year' functionality to definitions - https://github.com/holidays/holidays/issues/33 - (thanks to https://github.com/ttwo32)
* Fix 'day after thanksgiving' namespace bug during definition generation (thanks to https://github.com/ttwo32)
* fix Danish holidays 'palmesondag and 1/5 (danish fightday)' to set to informal (thanks to https://github.com/bjensen)

## 3.1.2

* Do not require Date monkeypatching in definitions to use mday calculations (thanks to https://github.com/CloCkWeRX)

## 3.1.1

* Require 'digest/md5' in main 'holidays' module. This was missed during the refactor (thanks to https://github.com/espen)

## 3.1.0

* Fix St. Stephen observance holiday for Ireland (https://github.com/gumchum)
* Add Bulgarian holidays (https://github.com/thekazak)
* Add new mountain holiday for Japan (https://github.com/ttwo32)
* Add ability to calculate Easter in either Gregorian (existing) or Julian (new) dates

## 3.0.0

* Major refactor! Lots of code moved around and some methods were removed from the public api (they were never intended to be public).
* Only supports ruby 2.0.0 and up. Travis config has been updated to reflect this.
* Moves 'date' monkeypatching out of main lib and makes it a core extension. See README for usage.
* Fixes remote execution bug in issue-86 (thanks to https://github.com/Intrepidd for reporting)
* No region definition changes.

I decided to make this a major version bump due to how much I changed. I truly hope no one will notice.
See the README for the usage. It has, except for the date core extension, not changed.

## 2.2.0

* Correct 'informal' type for Dodenherdenking holiday in NL definitions (https://github.com/MathijsK93)

## 2.1.0

* Updated Slovak holiday definitions (https://github.com/guitarman)
* Fix Japanese non-Monday substitute holidays (https://github.com/shuhei)
* Fixed typo in Slovak holiday definitions (https://github.com/martinsabo)
* Updated New Zealand definitions to reflect new weekend-to-monday rules (https://github.com/SebastianEdwards)
* Fix Australian definitions (https://github.com/ghiculescu)

## 2.0.0

* Add test coverage
* Remove support for Ruby 1.8.7 and REE. (https://github.com/itsmechlark)
* Add support for Ruby 2.2 (https://github.com/itsmechlark)
* Add PH holidays (https://github.com/itsmechlark)
* Belgian holidays now written in French instead of English (https://github.com/maximerety)
* Update California (USA) holidays to include Cesar Chavez and Thanksgiving (https://github.com/evansagge)

## 1.2.0

* Remove inauguration day from USA Federal Reserve definitions (https://github.com/aripollak)
* Add caching functionality for date ranges (https://github.com/ndbroadbent & https://github.com/ghiculescu)

## 1.1.0

* Add support to load custom holidays on the fly
* Add hobart & launceston show days (https://github.com/ghiculescu)
* Add Melbourne Cup day (https://github.com/ghiculescu)
* Add Hobart Regatte Day (https://github.com/ghiculescu)
* Add Costa Rican holidays (https://github.com/kevinwmerritt)
* Update Canadian Holidays (https://github.com/KevinBrowne)
* Add substitute holidays for Japan (https://github.com/YoshiyukiHirano)
* Fix USA Federal Reserve Holidays
* Add FedEx holidays (https://github.com/adamrunner)

## 1.0.7

* Load parent region even when sub region is not explicitly defined (https://github.com/csage)
* Full support for http://en.wikipedia.org/wiki/ISO_3166-2:DE (https://github.com/rojoko)
* Added Lithuanian definitions (https://github.com/Brunas)
* Added Chilean definitions (https://github.com/marcelo-soto)g
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
