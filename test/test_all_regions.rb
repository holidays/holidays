require File.expand_path(File.dirname(__FILE__)) + '/test_helper'

class MultipleRegionsTests < Test::Unit::TestCase

  def test_definition_dir
    assert File.directory?(Holidays::FULL_DEFINITIONS_PATH)
  end

  def test_getting_available_paths
    defs = Holidays.available(true)
    assert_equal def_count, defs.size

    defs.each do |f|
      assert f.kind_of?(String)
      assert File.exist?(f)
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

  def test_load_subregion
    Holidays.send(:remove_const, :DE) #unload de module so that is has to be loaded again
    Holidays.send(:class_variable_set, :@@regions, []) # reset regions
    holidays = Holidays.on(Date.civil(2014, 1, 1), :de_bb)

    assert holidays.any? { |h| h[:name] == 'Neujahrstag' }
  end

  def test_unknown_region_raises_exception
    assert_raise Holidays::UnknownRegionError do
      Holidays.on(Date.civil(2014, 1, 1), :something_we_do_not_recognize)
    end
  end

  def test_malicious_load_attempt_raises_exception
    assert_raise Holidays::UnknownRegionError do
      Holidays.between(Date.civil(2014, 1, 1), Date.civil(2016, 1, 1), '../../../../../../../../../../../../tmp/profile_pic.jpg')
    end
  end

private
  def def_count
    Dir.glob(Holidays::FULL_DEFINITIONS_PATH + '/*.rb').size
  end
end
