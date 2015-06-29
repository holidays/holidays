require 'holidays/definition/context/generator'
require 'holidays/definition/context/merger'

module Holidays
  module DefinitionFactory
    class << self
      def file_parser
        Definition::Context::Generator.new
      end

      def source_generator
        Definition::Context::Generator.new
      end

      def merger
        Definition::Context::Merger.new
      end
    end
  end
end
