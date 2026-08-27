require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays'
require 'holidays/definition/custom_methods/registry'

class DefinitionCustomMethodsRegistryTests < Test::Unit::TestCase
  def setup
    @all = Holidays::Definition::CustomMethods.all
  end

  def test_all_keys_are_full_call_signature_strings
    assert @all.keys.all? { |k| k =~ /\A[a-z_]+\([a-z, ]*\)\z/ }, @all.keys.inspect
    assert_includes @all.keys, "fi_juhannusaatto(year)"
    assert_includes @all.keys, "jp_substitute_holiday(year, month, day)"
    assert_includes @all.keys, "juneteenth_national_independence_day(region, date)"
  end

  def test_registers_every_native_method_exactly_once
    assert_equal @all.keys, @all.keys.uniq
    assert_equal 60, @all.size
  end

  def test_all_values_are_callable
    assert @all.values.all? { |v| v.respond_to?(:call) }
  end

  def test_boot_seeds_every_native_method_into_the_repository
    repo = Holidays::Factory::Definition.custom_methods_repository

    @all.each_key do |id|
      assert_not_nil repo.find(id), "expected #{id} to be seeded into the repository"
    end

    assert_equal Date.civil(2024, 6, 21), repo.find("fi_juhannusaatto(year)").call(2024)
    assert_equal Date.civil(2024, 5, 20), repo.find("ca_victoria_day(year)").call(2024)
  end

  def test_repository_returns_nil_for_an_unregistered_id
    assert_nil Holidays::Factory::Definition.custom_methods_repository.find("definitely_not_registered(year)")
  end
end
