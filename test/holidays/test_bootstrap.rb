require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays'

class BootstrapTests < Test::Unit::TestCase
  def test_builtin_global_methods_are_registered_at_boot
    repo = Holidays::Factory::Definition.custom_methods_repository

    assert_not_nil repo.find("easter(year)")
    assert_not_nil repo.find("lunar_to_solar(year, month, day, region)")
  end

  def test_bootstrap_is_not_publicly_accessible
    assert_raise(NameError) { Holidays::Bootstrap }
  end
end
