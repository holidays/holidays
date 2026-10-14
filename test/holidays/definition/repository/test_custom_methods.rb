require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'holidays/definition/repository/custom_methods'

class CustomMethodsRepoTests < Test::Unit::TestCase
  def setup
    @subject = Holidays::Definition::Repository::CustomMethods.new
  end

  def test_add_raises_error_if_input_is_nil
    assert_raise ArgumentError do
      @subject.add(nil)
    end
  end

  def test_find_returns_nil_if_method_id_does_not_exist
    assert_nil @subject.find("some-method-id")
  end

  def test_add_successfully_adds_new_custom_methods
    new_custom_methods = {
      "some-method-id" => Proc.new { |year|
        Date.civil(year, 1, 1)
      }
    }

    @subject.add(new_custom_methods)

    target_method = @subject.find("some-method-id")

    assert_equal new_custom_methods["some-method-id"], target_method
  end

  def test_find_raises_error_if_target_method_id_is_nil_or_empty
    assert_raise ArgumentError do
      @subject.find(nil)
    end

    assert_raise ArgumentError do
      @subject.find("")
    end
  end

  def test_add_raises_when_key_was_registered_without_a_source
    @subject.add({"easter(year)" => Proc.new { |year| Date.civil(year, 4, 1) }})

    assert_raise Holidays::DuplicateCustomMethod do
      @subject.add({"easter(year)" => Proc.new { |year| Date.civil(year, 5, 1) }}, {"easter(year)" => "Date.civil(year, 5, 1)"})
    end
  end

  def test_add_raises_when_key_is_readded_with_a_different_source
    original = Proc.new { |year| Date.civil(year, 9, 1) }
    @subject.add({"custom(year)" => original}, {"custom(year)" => "Date.civil(year, 9, 1)"})

    error = assert_raise Holidays::DuplicateCustomMethod do
      @subject.add({"custom(year)" => Proc.new { |year| Date.civil(year, 11, 1) }}, {"custom(year)" => "Date.civil(year, 11, 1)"})
    end

    assert_match(/custom\(year\)/, error.message)
    assert_equal original, @subject.find("custom(year)")
  end

  def test_add_is_a_noop_when_key_is_readded_with_an_identical_source
    original = Proc.new { |year| Date.civil(year, 9, 1) }
    @subject.add({"custom(year)" => original}, {"custom(year)" => "Date.civil(year, 9, 1)"})

    assert_nothing_raised do
      @subject.add({"custom(year)" => Proc.new { |year| Date.civil(year, 9, 1) }}, {"custom(year)" => "Date.civil(year, 9, 1)"})
    end

    assert_equal original, @subject.find("custom(year)")
  end

  def test_failed_add_inserts_nothing
    @subject.add({"existing(year)" => Proc.new { |year| Date.civil(year, 1, 1) }})

    assert_raise Holidays::DuplicateCustomMethod do
      @subject.add(
        {
          "brand_new(year)" => Proc.new { |year| Date.civil(year, 2, 1) },
          "existing(year)" => Proc.new { |year| Date.civil(year, 3, 1) },
        },
        {"brand_new(year)" => "Date.civil(year, 2, 1)", "existing(year)" => "Date.civil(year, 3, 1)"},
      )
    end

    assert_nil @subject.find("brand_new(year)")
  end
end
