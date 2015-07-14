require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

require 'holidays/use_case_factory'

class UseCaseFactoryTests < Test::Unit::TestCase
  def test_between_factory
    assert Holidays::UseCaseFactory.between.is_a?(Holidays::UseCase::Context::Between)
  end
end
