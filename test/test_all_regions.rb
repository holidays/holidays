require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class MultipleRegionsTests < Test::Unit::TestCase

  def test_definition_dir
    assert File.directory?(Holidays::DEFINITION_PATH)
  end
  
  def test_getting_available_paths
    defs = Holidays.available(true)
    assert_equal def_count, defs.size
    
    defs.each do |f|
      assert f.kind_of?(String)
      assert File.exists?(f)
    end
  end
  
  def test_getting_available_symbols
    defs = Holidays.available(false)
    assert_equal def_count, defs.size
    
    defs.each { |f| assert f.kind_of?(Symbol) }
    
    # some spot checks
    assert defs.include?(:ca)
    assert defs.include?(:united_nations)
  end

  
  def test_loading_all
    Holidays.load_all
    holidays = Holidays.on(Date.civil(2011, 5, 1), :any)

    # at least 15 now, but there could be more in the future
    assert holidays.size > 15 

    # some spot checks
    assert holidays.any? { |h| h[:name] == 'Staatsfeiertag' }  # :at
    assert holidays.any? { |h| h[:name] == 'Dia do Trabalho' } # :br
    assert holidays.any? { |h| h[:name] == 'Vappu' }           # :fi
  end

  def test_getting_regions
    Holidays.load_all
    regions = Holidays.regions

    assert regions.size > 30

    assert regions.include? :nyse
    assert regions.include? :united_nations
  end
  
private
  def def_count
    Dir.glob(Holidays::DEFINITION_PATH + '/*.rb').size
  end  
end
