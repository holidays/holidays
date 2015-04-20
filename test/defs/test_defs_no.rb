# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# This file is generated by the Ruby Holiday gem.
#
# Definitions loaded: data/no.yaml
class NoDefinitionTests < Test::Unit::TestCase  # :nodoc:

  def test_no
{Date.civil(2010,1,1) => 'Nyttårsdag',
 Date.civil(2010,5,1) => '1. mai',
 Date.civil(2010,5,17) => '17. mai',
 Date.civil(2010,12,24) => 'Julaften',
 Date.civil(2010,12,25) => '1. juledag',
 Date.civil(2010,12,26) => '2. juledag',
 Date.civil(2010,12,31) => 'Nyttårsaften',
 Date.civil(2010,2,14) => 'Fastelavn',
 Date.civil(2010,3,28) => 'Palmesøndag',
 Date.civil(2010,4,1) => 'Skjærtorsdag',
 Date.civil(2010,4,2) => 'Langfredag',
 Date.civil(2010,4,4) => '1. påskedag',
 Date.civil(2010,4,5) => '2. påskedag',
 Date.civil(2010,5,13) => 'Kristi Himmelfartsdag',
 Date.civil(2010,5,23) => '1. pinsedag',
 Date.civil(2010,5,24) => '2. pinsedag'}.each do |date, name|
   assert_equal name, (Holidays.on(date, :no, :informal)[0] || {})[:name]
 end
  end
end
