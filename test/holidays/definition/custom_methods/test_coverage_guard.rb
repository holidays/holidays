require File.expand_path(File.dirname(__FILE__)) + '/../../../test_helper'

require 'yaml'
require 'holidays'

# Every +function:+ / +observed:+ id referenced anywhere in the definitions
# submodule must resolve in the custom methods repository (built-in globals plus
# the native per-region modules). A gap here means some region would raise
# Holidays::FunctionNotFound at runtime, so this must fail `rake test`.
class DefinitionCustomMethodsCoverageGuardTests < Test::Unit::TestCase
  DEFINITIONS_GLOB = File.expand_path(File.dirname(__FILE__)) + '/../../../../definitions/*.yaml'

  def test_all_referenced_function_ids_resolve_in_the_repository
    assert Dir[DEFINITIONS_GLOB].any?, "definitions submodule is not checked out (git submodule update --init)"

    repo = Holidays::Factory::Definition.custom_methods_repository

    referenced = Hash.new { |h, k| h[k] = [] }

    Dir[DEFINITIONS_GLOB].sort.each do |file|
      data = YAML.safe_load(File.read(file))
      next unless data && data['months']

      data['months'].each_value do |rules|
        Array(rules).each do |rule|
          next unless rule.is_a?(Hash)
          [rule['function'], rule['observed']].compact.each do |id|
            referenced[id] << File.basename(file)
          end
        end
      end
    end

    assert_operator referenced.size, :>=, 70, "expected to discover the full set of function ids"

    missing = referenced.reject { |id, _| repo.find(id) }

    assert_empty(
      missing.map { |id, files| "#{id} (referenced by #{files.uniq.join(', ')})" },
      "function ids with no implementation in the repository",
    )
  end
end
