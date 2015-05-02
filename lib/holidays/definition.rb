require 'holidays/definition/generator'

module Holidays
  module Definition
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
