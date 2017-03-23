require 'holidays/option/context/parse_options'

module Holidays
  module OptionFactory
    class << self
      def parse_options
        Option::Context::ParseOptions.new(
          DefinitionFactory.regions_repository,
          DefinitionFactory.region_validator
        )
      end
    end
  end
end
