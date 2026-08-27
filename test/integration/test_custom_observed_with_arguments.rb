require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# Regression test: load_custom must populate :observed_arguments for observed
# methods that take arguments other than 'date'. Before the fix, the parse path
# only set :function_arguments, so build_observed_date fell back to [:date] and
# called a multi-argument observed proc with a single argument, raising
# NoMethodError.
class CustomObservedWithArgumentsTest < Test::Unit::TestCase
  def setup
    Holidays.load_custom('test/integration/data/test_custom_observed_with_arguments_defs.yaml')
  end

  def test_observed_method_with_region_and_date_arguments_resolves
    # 2021-06-19 is a Saturday, so the observed date moves to Monday the 21st.
    holidays = Holidays.on(Date.civil(2021, 6, 21), :custom_observed_with_args, [:observed])

    assert_equal "Custom Observed Holiday", (holidays[0] || {})[:name]
  end
end
