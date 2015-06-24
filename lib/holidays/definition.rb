require 'holidays/definition/generator'

module Holidays
  module Definition #TODO This should be named a 'factory' for clarity
    class << self
      def file_parser
        Generator.new
      end

      def source_generator
        Generator.new
      end
    end
  end
end
