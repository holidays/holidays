require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/generator/regions'

class GeneratorRegionsTests < Test::Unit::TestCase
  def setup
    @generator = Holidays::Definition::Generator::Regions.new
  end

  def test_generates_regions_single_region_multiple_subregions
    regions = {:region1 => [:test, :test2]}
    region_names = {:test => "Test One", :test2 => "Test Two"}
    expected = <<-EOE
# encoding: utf-8
module Holidays
  REGIONS = [:test, :test2]

  PARENT_REGION_LOOKUP = {test: :region1, test2: :region1}

  REGION_NAMES = {:test => "Test One", :test2 => "Test Two"}
end
EOE

    assert_equal expected, @generator.call(regions, region_names)
  end

  def test_generates_regions_multiple_regions_single_unique_subregions
    regions = {:region1 => [:test], :region2 => [:test2]}
    region_names = {:test => "Test One", :test2 => "Test Two"}
    expected = <<-EOE
# encoding: utf-8
module Holidays
  REGIONS = [:test, :test2]

  PARENT_REGION_LOOKUP = {test: :region1, test2: :region2}

  REGION_NAMES = {:test => "Test One", :test2 => "Test Two"}
end
EOE

    assert_equal expected, @generator.call(regions, region_names)
  end

  def test_generates_regions_multiple_regions_multiple_overlapping_subregions
    regions = {:region1 => [:test], :region2 => [:test, :test2], :region3 => [:test3, :test]}
    region_names = {:test => "Test One", :test2 => "Test Two", :test3 => "Test Three"}
    expected = <<-EOE
# encoding: utf-8
module Holidays
  REGIONS = [:test, :test2, :test3]

  PARENT_REGION_LOOKUP = {test: :region1, test2: :region2, test3: :region3}

  REGION_NAMES = {:test => "Test One", :test2 => "Test Two", :test3 => "Test Three"}
end
EOE

    assert_equal expected, @generator.call(regions, region_names)
  end

  def test_generates_regions_multiple_regions_multiple_overlapping_subregions_complex
    regions = {
      :region1 => [:test],
      :region2 => [:test, :test2],
      :region3 => [:test3, :test],
      :region4 => [:test4, :test2],
      :region5 => [:test4, :test5, :test3],
      :region6 => [:test4, :test6, :test],
    }
    region_names = {}

    expected = <<-EOE
# encoding: utf-8
module Holidays
  REGIONS = [:test, :test2, :test3, :test4, :test5, :test6]

  PARENT_REGION_LOOKUP = {test: :region1, test2: :region2, test3: :region3, test4: :region4, test5: :region5, test6: :region6}

  REGION_NAMES = {}
end
EOE

    assert_equal expected, @generator.call(regions, region_names)
  end

  def test_generates_region_names_with_yaml_reserved_key
    # 'no' (Norway) parses to boolean false in YAML unless quoted; the parser
    # yields it as the :no symbol, and the generated literal must round-trip it
    # back to a real :no key, not a stale boolean.
    regions = {:no => [:no]}
    region_names = {:no => "Norway"}
    expected = <<-EOE
# encoding: utf-8
module Holidays
  REGIONS = [:no]

  PARENT_REGION_LOOKUP = {no: :no}

  REGION_NAMES = {:no => "Norway"}
end
EOE

    assert_equal expected, @generator.call(regions, region_names)
  end

  def test_generates_region_names_escaping_special_characters_in_values
    regions = {:region1 => [:test]}
    region_names = {:test => %q{Côte d'Ivoire "x", y}}
    result = @generator.call(regions, region_names)

    assert_match(/REGION_NAMES = \{:test => #{Regexp.escape(%q{"Côte d'Ivoire \"x\", y"})}\}/, result)
  end

  def test_region_names_defaults_to_empty_when_omitted
    regions = {:region1 => [:test]}

    assert_match(/REGION_NAMES = \{\}/, @generator.call(regions))
  end

  def test_returns_error_if_regions_is_empty
    regions = {}

    assert_raises ArgumentError do
      @generator.call(regions)
    end
  end

  def test_returns_error_if_regions_is_not_a_hash
    regions = "invalid"

    assert_raises ArgumentError do
      @generator.call(regions)
    end
  end

  def test_returns_error_if_regions_is_nil
    regions = nil

    assert_raises ArgumentError do
      @generator.call(regions)
    end
  end
end
