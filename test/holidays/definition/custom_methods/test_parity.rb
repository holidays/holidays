require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'yaml'
require 'holidays'
require 'holidays/definition/custom_methods/registry'

# Old-vs-new comparison. While the definitions submodule still carries the
# +methods:/ruby:+ blocks we can build the OLD proc by eval'ing that source
# (exactly as Holidays.load_custom does) and compare it, across a wide input
# sweep, against the NEW native proc resolved from the registry. Any divergence
# fails the build.
class DefinitionCustomMethodsParityTests < Test::Unit::TestCase
  DEFINITIONS_GLOB = File.expand_path(File.dirname(__FILE__)) + '/../../../../definitions/*.yaml'

  YEARS = (1990..2060).to_a

  def setup
    @parser = Holidays::Factory::Definition.custom_method_parser
    @decorator = Holidays::Factory::Definition.custom_method_proc_decorator
    @repo = Holidays::Factory::Definition.custom_methods_repository
  end

  def test_every_yaml_method_matches_its_native_registry_implementation
    assert Dir[DEFINITIONS_GLOB].any?, "definitions submodule is not checked out (git submodule update --init)"

    checked = 0

    Dir[DEFINITIONS_GLOB].sort.each do |file|
      data = YAML.safe_load(File.read(file))
      next unless data && data['methods']

      old_procs = @parser.call(data['methods'])

      old_procs.each do |signature, entity|
        old_proc = @decorator.call(entity)
        new_proc = @repo.find(signature)

        assert_not_nil new_proc, "#{signature} (#{File.basename(file)}) is not registered natively"

        each_input(entity.arguments) do |args|
          assert_equal(
            invoke(old_proc, args),
            invoke(new_proc, args),
            "#{signature} (#{File.basename(file)}) diverged for args #{args.inspect}",
          )
          checked += 1
        end
      end
    end

    assert_operator checked, :>, 5_000, "parity sweep ran too few comparisons"
  end

  private

  # Returns the value, or a marker describing the raised error class so that
  # "both sides raise the same thing" counts as a match.
  def invoke(proc, args)
    proc.call(*args)
  rescue => e
    [:raised, e.class.name]
  end

  def each_input(arguments)
    case arguments
    when ['year']
      YEARS.each { |y| yield [y] }
    when ['date']
      Date.new(2010, 1, 1).step(Date.new(2040, 12, 31)).each { |d| yield [d] }
    when ['year', 'month']
      YEARS.each { |y| (1..12).each { |m| yield [y, m] } }
    when ['year', 'month', 'day']
      YEARS.each { |y| (1..12).each { |m| (1..28).each { |d| yield [y, m, d] } } }
    when ['region', 'date']
      [:us, :us_ut, :us_ny].each do |r|
        Date.new(2015, 6, 1).step(Date.new(2035, 6, 30)).each { |d| yield [r, d] }
      end
    else
      flunk "parity sweep has no input strategy for arguments #{arguments.inspect}"
    end
  end
end
