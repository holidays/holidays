require File.dirname(__FILE__) + '/test_helper'
require 'fixtures/mixin_module'

class MixinTests < Test::Unit::TestCase
  def test_tester
    #Holidays.append_features(Holidays::MixinModule)
    puts Holidays.constants
    puts Holidays::DEFINED_REGIONS.join(',')
    assert Holidays.method_defined?(:test_lambda)
  end

  def test_adding_region_constants
  
  end
end
